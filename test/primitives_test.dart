import 'dart:convert';
import 'dart:io' show stderr;

import 'package:angel_container/mirrors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:mock_request/mock_request.dart';
import 'package:test/test.dart';

main() {
  Angel app;
  AngelHttp http;

  setUp(() {
    app = new Angel(reflector: MirrorsReflector())
      ..configuration['global'] = 305; // Pitbull!
    http = new AngelHttp(app);

    app.get('/string/:string', ioc((String string) => string));

    app.get(
        '/num/parsed/:num',
        chain([
          (req, res) {
            req.params['n'] = num.parse(req.params['num'].toString());
            return true;
          },
          ioc((num n) => n),
        ]));

    app.get('/num/global', ioc((num global) => global));

    app.errorHandler = (e, req, res) {
      stderr..writeln(e.error)..writeln(e.stackTrace);
    };
  });

  tearDown(() => app.close());

  test('String type annotation', () async {
    var rq = new MockHttpRequest('GET', Uri.parse('/string/hello'))..close();
    await http.handleRequest(rq);
    var rs = await rq.response.transform(utf8.decoder).join();
    expect(rs, json.encode('hello'));
  });

  test('Primitive after parsed param injection', () async {
    var rq = new MockHttpRequest('GET', Uri.parse('/num/parsed/24'))..close();
    await http.handleRequest(rq);
    var rs = await rq.response.transform(utf8.decoder).join();
    expect(rs, json.encode(24));
  });

  test('globally-injected primitive', () async {
    var rq = new MockHttpRequest('GET', Uri.parse('/num/global'))..close();
    await http.handleRequest(rq);
    var rs = await rq.response.transform(utf8.decoder).join();
    expect(rs, json.encode(305));
  });

  test('unparsed primitive throws error', () async {
    try {
      var rq = new MockHttpRequest('GET', Uri.parse('/num/unparsed/32'))
        ..close();
      var req = await http.createRequestContext(rq, rq.response);
      var res = await http.createResponseContext(rq, rq.response, req);
      await app.runContained((num unparsed) => unparsed, req, res);
      throw new StateError(
          'ArgumentError should be thrown if a parameter cannot be resolved.');
    } on ArgumentError {
      // Success
    }
  });
}
