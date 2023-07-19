import 'package:shelf/src/middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

class CORSHeadersHandler {
  final overrideHeaders = {
    // TODO: Replace with Cloud Provision Frontend URLs during build & deployment
    ACCESS_CONTROL_ALLOW_HEADERS: '*',
    'Content-Type': 'application/json;charset=utf-8',
  };

  Middleware corsHeadersHandler() {
    return corsHeaders(
      headers: overrideHeaders,
    );
  }
}
