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
      return Response.ok(
          jsonResponseEncode(await _templatesService.getTemplates()));
    } on Exception catch (e) {
      print(e);
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
