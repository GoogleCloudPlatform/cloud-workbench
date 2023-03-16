import 'dart:io';

import 'package:cloud_provision_server/controllers/ServerController.dart';
import 'package:cloud_provision_server/middleware/CORSHeadersHandler.dart';
import 'package:cloud_provision_server/middleware/TokenValidationHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '5000');

  ServerController serverController = ServerController();
  TokenValidationHandler tokenValidationHandler = TokenValidationHandler();

  var flutterWebAppPath = "/app/bin/public";

  final staticHandler = createStaticHandler(flutterWebAppPath, defaultDocument: 'index.html');
  final staticAssetsHandler = createStaticHandler(flutterWebAppPath + '/assets');

  final handlerPipeline = const Pipeline()
      .addMiddleware(tokenValidationHandler.tokenValidationHandler())
      .addHandler(serverController.handler);

  var handler = Cascade()
      .add(staticHandler)
      .add(staticAssetsHandler)
      .add(handlerPipeline)
      .handler;

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
