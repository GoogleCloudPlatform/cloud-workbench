import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../services/TemplatesService.dart';

class TemplatesController extends BaseController {
  TemplatesService _templatesService = TemplatesService();

  Router get router {
    final router = Router();
    router.get('/', _getTemplatesHandler);
    return router;
  }

  Future<Response> _getTemplatesHandler(Request request) async {
    try {
      final queryParams = request.url.queryParameters;
      final templateId = queryParams['templateId'];

      if (templateId != null) {
        return _getTemplateByIdHandler(request);
      }

      return Response.ok(jsonResponseEncode(
          await _templatesService.getTemplates(
              queryParams['catalogSource']!, queryParams['catalogUrl']!)));
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _getTemplateByIdHandler(Request request) async {
    try {
      String? t = request.url.queryParameters['templateId'];
      int templateId = int.parse(t!);

      String? catalogSource = request.url.queryParameters['catalogSource'];

      return Response.ok(jsonResponseEncode(
          await _templatesService.getTemplateById(templateId, catalogSource!)));
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
