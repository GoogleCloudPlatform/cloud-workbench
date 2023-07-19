import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:cloud_provision_server/services/SecurityService.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class SecurityController extends BaseController {
  SecurityService _securityService = SecurityService();

  Router get router {
    final router = Router();
    router.get(
        '/<serviceId>/recommendations', _getSecurityRecommendationsHandler);
    router.get(
        '/<serviceId>/vulnerabilities', _getContainerVulnerabilitiesHandler);
    return router;
  }

  Future<Response> _getSecurityRecommendationsHandler(Request request) async {
    try {
      String serviceId = request.params['serviceId']!;
      String projectId = request.url.queryParameters['projectId']!;

      List<Map> response = await _securityService.getSecurityRecommendations(
          projectId, serviceId);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode(response),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode(
              {"msg": "Failed to get security recommendations"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _getContainerVulnerabilitiesHandler(Request request) async {
    try {
      String serviceId = request.params['serviceId']!;
      String projectId = request.url.queryParameters['projectId']!;

      List<Map> response = await _securityService.getContainerVulnerabilities(
          projectId, serviceId);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode(response),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode(
              {"msg": "Failed to get container vulnerabilities"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
