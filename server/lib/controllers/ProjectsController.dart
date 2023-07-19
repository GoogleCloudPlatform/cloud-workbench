import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'dart:io';

import 'package:cloud_provision_server/services/ProjectsService.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ProjectsController extends BaseController {
  ProjectsService _projectsService = ProjectsService();

  Router get router {
    final router = Router();
    router.get('/', _getProjectsHandler);
    return router;
  }

  Future<Response> _getProjectsHandler(Request request) async {
    try {
      String userIdentityToken = _getUserIdentityToken(request);

      return Response.ok(
        jsonResponseEncode(
            await _projectsService.getUserProjects(userIdentityToken)),
      );
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  String _getUserIdentityToken(Request request) {
    String userIdentityToken = "";

    String? authorization = request.headers[HttpHeaders.authorizationHeader];
    List<String> tokens = authorization!.split(" ");
    if (tokens.length != 2 || tokens[0] != "Bearer") {
      return userIdentityToken;
    }

    userIdentityToken = authorization;

    return userIdentityToken;
  }
}
