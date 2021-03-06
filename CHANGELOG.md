# 2.0.0-alpha.17
* Revert the migration to `lumberjack` for now. In the future, when it's more
stable, there'll be a conversion, perhaps.

# 2.0.0-alpha.16
* Use `package:lumberjack` for logging.

# 2.0.0-alpha.15
* Remove dependency on `body_parser`.
* `RequestContext` now exposes a `Stream<List<int>> get body` getter.
    * Calling `RequestContext.parseBody()` parses its contents.
    * Added `bodyAsMap`, `bodyAsList`, `bodyAsObject`, and `uploadedFiles` to `RequestContext`.
    * Removed `Angel.keepRawRequestBuffers` and anything that had to do with buffering request bodies.

# 2.0.0-alpha.14
* Patch `HttpResponseContext._openStream` to send content-length.

# 2.0.0-alpha.13

- Fixed a logic error in `HttpResponseContext` that prevented status codes from being sent.

# 2.0.0-alpha.12

- Remove `ResponseContext.sendFile`.
- Add `Angel.mimeTypeResolver`.
- Fix a bug where an unknown MIME type on `streamFile` would return a 500.

# 2.0.0-alpha.11

- Add `readMany` to `Service`.
- Allow `ResponseContext.redirect` to take a `Uri`.
- Add `Angel.mountController`.
- Add `Angel.findServiceOf`.
- Roll in HTTP/2. See `pkg:angel_framework/http2.dart`.

# 2.0.0-alpha.10

- All calls to `Service.parseId` are now affixed with the `<Id>` argument.
- Added `uri` getter to `AngelHttp`.
- The default for `parseQuery` now wraps query parameters in `new Map<String, dynamic>.from`.
  This resolves a bug in `package:angel_validate`.

# 2.0.0-alpha.9

- Add `Service.map`.

# 2.0.0-alpha.8

- No longer export HTTP-specific code from `angel_framework.dart`.
  An import of `import 'package:angel_framework/http.dart';` will be necessary in most cases now.

# 2.0.0-alpha.7

- Force a tigher contract on services. They now must return `Data` on all
  methods except for `index`, which returns a `List<Data>`.

# 2.0.0-alpha.6

- Allow passing a custom `Container` to `handleContained` and co.

# 2.0.0-alpha.5

- `MapService` methods now explicitly return `Map<String, dynamic>`.

# 2.0.0-alpha.4

- Renamed `waterfall` to `chain`.
- Renamed `Routable.service` to `Routable.findService`.
  - Also `Routable.findHookedService`.

# 2.0.0-alpha.3

- Added `<Id, Data>` type parameters to `Service`.
- `HookedService` now follows suit, and takes a third parameter, pointing to the inner service.
- `Routable.use` now uses the generic parameters added to `Service`.
- Added generic usage to `HookedServiceListener`, etc.
- All service methods take `Map<String, dynamic>` as `params` now.

# 2.0.0-alpha.2

- Added `ResponseContext.detach`.

# 2.0.0-alpha.1

- Removed `Angel.injectEncoders`.
- Added `Providers.toJson`.
- Moved `Providers.graphql` to `Providers.graphQL`.
- `Angel.optimizeForProduction` no longer calls `preInject`,
  as it does not need to.
- Rename `ResponseContext.enableBuffer` to `ResponseContext.useBuffer`.

# 2.0.0-alpha

- Removed `random_string` dependency.
- Moved reflection to `package:angel_container`.
- Upgraded `package:file` to `5.0.0`.
- `ResponseContext.sendFile` now uses `package:file`.
- Abandon `ContentType` in favor of `MediaType`.
- Changed view engine to use `Map<String, dynamic>`.
- Remove dependency on `package:json_god` by default.
- Remove dependency on `package:dart2_constant`.
- Moved `lib/hooks.dart` into `package:angel_hooks`.
- Moved `TypedService` into `package:angel_typed_service`.
- Completely removed the `AngelBase` class.
- Removed all `@deprecated` symbols.
- `Service.toId` was renamed to `Service.parseId`; it also now uses its
  single type argument to determine how to parse a value. \* In addition, this method was also made `static`.
- `RequestContext` and `ResponseContext` are now generic, and take a
  single type argument pointing to the underlying request/response type,
  respectively.
- `RequestContext.io` and `ResponseContext.io` are now permanently
  gone.
- `HttpRequestContextImpl` and `HttpResponseContextImpl` were renamed to
  `HttpRequestContext` and `HttpResponseContext`.
- Lazy-parsing request bodies is now the default; `Angel.lazyParseBodies` was replaced
  with `Angel.eagerParseRequestBodies`.
- `Angel.storeOriginalBuffer` -> `Angel.storeRawRequestBuffers`.
- The methods `lazyBody`, `lazyFiles`, and `lazyOriginalBuffer` on `ResponseContext` were all
  replaced with `parseBody`, `parseUploadedFiles`, and `parseRawRequestBuffer`, respectively.
- Removed the synchronous equivalents of the above methods (`body`, `files`, and `originalBuffer`),
  as well as `query`.
- Removed `Angel.injections` and `RequestContext.injections`.
- Removed `Angel.inject` and `RequestContext.inject`.
- Removed a dependency on `package:pool`, which also meant removing `AngelHttp.throttle`.
- Remove the `RequestMiddleware` typedef; from now on, one should use `ResponseContext.end`
  exclusively to close responses.
- `waterfall` will now only accept `RequestHandler`.
- `Routable`, and all of its subclasses, now extend `Router<RequestHandler>`, and therefore only
  take routes in the form of `FutureOr myFunc(RequestContext, ResponseContext res)`.
- `@Middleware` now takes an `Iterable` of `RequestHandler`s.
- `@Expose.path` now _must_ be a `String`, not just any `Pattern`.
- `@Expose.middleware` now takes `Iterable<RequestHandler>`, instead of just `List`.
- `createDynamicHandler` was renamed to `ioc`, and is now used to run IoC-aware handlers in a
  type-safe manner.
- `RequestContext.params` is now a `Map<String, dynamic>`, rather than just a `Map`.
- Removed `RequestContext.grab`.
- Removed `RequestContext.properties`.
- Removed the defunct `debug` property where it still existed.
- `Routable.use` now only accepts a `Service`.
- Removed `Angel.createZoneForRequest`.
- Removed `Angel.defaultZoneCreator`.
- Added all flags to the `Angel` constructor, ex. `Angel.eagerParseBodies`.
- Fix a bug where synchronous errors in `handleRequest` would not be caught.
- `AngelHttp.useZone` now defaults to `false`.
- `ResponseContext` now starts in streaming mode by default; the response buffer is opt-in,
  as in many cases it is unnecessary and slows down response time.
- `ResponseContext.streaming` was replaced by `ResponseContext.isBuffered`.
- Made `LockableBytesBuilder` public.
- Removed the now-obsolete `ResponseContext.willCloseItself`.
- Removed `ResponseContext.dispose`.
- Removed the now-obsolete `ResponseContext.end`.
- Removed the now-obsolete `ResponseContext.releaseCorrespondingRequest`.
- `preInject` now takes a `Reflector` as its second argument.
- `Angel.reflector` defaults to `const EmptyReflector()`, disabling
  reflection out-of-the-box.
