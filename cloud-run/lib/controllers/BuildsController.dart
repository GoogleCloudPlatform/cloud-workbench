import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../services/BuildsService.dart';

import 'dart:convert';

import 'package:cloud_provision_server/models/template_model.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;
import 'package:http/http.dart' as http;

import '../services/TemplatesService.dart';

class BuildsController extends BaseController {
  BuildsService _buildsService = BuildsService();
  TemplatesService _templatesService = TemplatesService();

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
    } on Exception catch (e) {
      print(e);
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _startBuildHandler(Request request) async {
    try {
      final body = await request.readAsString();
      Map<String, dynamic> requestMap = jsonDecode(body);

      List<TemplateModel> templates = await _templatesService.getTemplates();
      var templatesMap =
          Map.fromIterable(templates, key: (t) => t.id, value: (t) => t);

      TemplateModel? template =
          templatesMap[int.parse(requestMap['template_id'])];

      Map<String, dynamic> cloudProvisionJsonConfig =
          await _fetchCloudProvisionConfig(template!.cloudProvisionConfigUrl);

      var projectId = requestMap['project_id'];

      Map<String, String> substitutionsMap =
          Map<String, String>.from(requestMap['params']);

      cb.Operation buildOp = await _buildsService.startBuild(
          projectId, substitutionsMap, cloudProvisionJsonConfig);

      return Response.ok(
        jsonResponseEncode(buildOp.metadata),
      );
    } on Exception catch (e) {
      print(e);
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchCloudProvisionConfig(
      String cloudProvisionConfigUrl) async {
    final http.Client client = new http.Client();
    var response = await client.get(Uri.parse(cloudProvisionConfigUrl));
    return json.decode(response.body);
  }
}
