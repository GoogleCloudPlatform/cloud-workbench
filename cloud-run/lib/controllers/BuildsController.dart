import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:cloud_provision_server/services/ConfigService.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../services/BuildsService.dart';

import 'dart:convert';

import 'package:cloud_provision_server/models/template_model.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;

import '../services/TemplatesService.dart';

class BuildsController extends BaseController {
  BuildsService _buildsService = BuildsService();
  TemplatesService _templatesService = TemplatesService();
  ConfigService _configService = ConfigService();

  Router get router {
    final router = Router();
    router.get('/', _getBuildHandler);
    router.post('/', _startBuildHandler);
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

      List<Template> templates = await _templatesService.getTemplates();
      var templatesMap =
          Map.fromIterable(templates, key: (t) => t.id, value: (t) => t);

      Template? template = templatesMap[int.parse(requestMap['template_id'])];

      Map<String, dynamic> cloudProvisionJsonConfig =
          await _configService.getJson(template!.cloudProvisionConfigUrl);

      var cloudProvisionJsonConfigList =
          cloudProvisionJsonConfig['cloudbuild']['steps'];

      var projectId = requestMap['project_id'];

      Map<String, String> substitutionsMap =
          Map<String, String>.from(requestMap['params']);

      cb.Operation buildOp = await _buildsService.startBuild(
          projectId, substitutionsMap, cloudProvisionJsonConfigList);

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
