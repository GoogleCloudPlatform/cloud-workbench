import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../services/BuildsService.dart';

import 'dart:convert';

import 'package:googleapis/cloudbuild/v1.dart' as cb;

class BuildsController extends BaseController {
  BuildsService _buildsService = BuildsService();

  Router get router {
    final router = Router();
    router.get('/', _getBuildHandler);
    router.post('/', _startBuildHandler);
    router.delete('/', _startBuildHandler);
    return router;
  }

  Future<Response> _getBuildHandler(Request request) async {
    try {
      String? projectId = request.url.queryParameters['projectId'];
      String? buildId = request.url.queryParameters['buildId'];

      return Response.ok(
        jsonResponseEncode(
            await _buildsService.getBuildDetails(projectId, buildId)),
      );
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _startBuildHandler(Request request) async {
    try {
      final body = await request.readAsString();
      Map<String, dynamic> requestMap = jsonDecode(body);

      var projectId = requestMap['project_id'];
      var templateConfigUrl = requestMap['cloudProvisionConfigUrl'];
      Map<String, String> substitutionsMap =
          Map<String, String>.from(requestMap['params']);

      cb.Operation buildOp = await _buildsService.startBuild(
          projectId, substitutionsMap, templateConfigUrl, request.method);

      return Response.ok(
        jsonResponseEncode(buildOp.metadata),
      );
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
