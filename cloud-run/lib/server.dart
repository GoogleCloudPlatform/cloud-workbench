import 'dart:io';

import 'package:cloud_provision_server/controllers/ServerController.dart';
import 'package:cloud_provision_server/middleware/CORSHeadersHandler.dart';
import 'package:cloud_provision_server/middleware/TokenValidationHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  ServerController serverController = ServerController();
  TokenValidationHandler tokenValidationHandler = TokenValidationHandler();
  CORSHeadersHandler corsHeadersHandler = CORSHeadersHandler();

  final handler = const Pipeline()
      .addMiddleware(corsHeadersHandler.corsHeadersHandler())
      .addMiddleware(tokenValidationHandler.tokenValidationHandler())
      .addHandler(serverController.handler);

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
