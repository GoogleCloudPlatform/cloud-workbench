import 'dart:io';

import 'package:cloud_provision_server/controllers/ServerController.dart';
import 'package:cloud_provision_server/middleware/CORSHeadersHandler.dart';
import 'package:cloud_provision_server/middleware/TokenValidationHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  ServerController serverController = ServerController();
  TokenValidationHandler tokenValidationHandler = TokenValidationHandler();
  CORSHeadersHandler corsHeadersHandler = CORSHeadersHandler();

  final handlerPipeline = const Pipeline()
      .addMiddleware(corsHeadersHandler.corsHeadersHandler())
      .addMiddleware(tokenValidationHandler.tokenValidationHandler())
      .addHandler(serverController.handler);

  var handler;

  if (Platform.isMacOS || Platform.isWindows) {
    handler = const Pipeline()
        .addMiddleware(corsHeadersHandler.corsHeadersHandler())
        .addMiddleware(tokenValidationHandler.tokenValidationHandler())
        .addHandler(serverController.handler);
  } else {
    var flutterWebAppPath =
        Platform.environment['WEBAPP_PATH'] ?? "/app/bin/public";

    final staticHandler =
        createStaticHandler(flutterWebAppPath, defaultDocument: 'index.html');
    final staticAssetsHandler =
        createStaticHandler(flutterWebAppPath + '/assets');

    handler = Cascade()
        .add(staticHandler)
        .add(staticAssetsHandler)
        .add(handlerPipeline)
        .handler;
  }

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    port,
  );

  server.autoCompress = true;

  print('Serving at ${server.address.host}:${server.port}');
}
