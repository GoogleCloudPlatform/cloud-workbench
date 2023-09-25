// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
