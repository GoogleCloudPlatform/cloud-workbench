import 'dart:io';

import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'dart:convert';

class EnvController extends BaseController {

  Router get router {
    final router = Router();
    router.get('/', _getEnvHandler);

    return router;
  }

  static const String firebaseConfigVar = "FIREBASE_CONFIG";

  Future<Response> _getEnvHandler(Request request) async {
    var firebaseConfig = {
      firebaseConfigVar: Platform.environment[firebaseConfigVar]
    };

    return Response.ok(jsonEncode(firebaseConfig));
  }
}
