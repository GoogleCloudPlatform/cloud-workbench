import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'dart:convert';
import 'package:googleapis/cloudbuild/v1.dart' as cb;
import '../services/TriggersService.dart';

class TriggersController extends BaseController {
  TriggersService _triggersService = TriggersService();

  Router get router {
    final router = Router();
    router.post('/', _runTriggerHandler);
    return router;
  }

  Future<Response> _runTriggerHandler(Request request) async {
    try {
      final body = await request.readAsString();
      Map<String, dynamic> requestMap = jsonDecode(body);

      String projectId = requestMap['project_id'];
      // String branchName = requestMap['branch_name'];
      // if (branchName == null || branchName == "") {
      //   branchName = "main";
      // }
      String branchName = "main";

      var triggerName = requestMap['app_name'] + "-trigger";

      cb.Operation operation =
          await _triggersService.runTrigger(projectId, branchName, triggerName);

      if (operation != null) {
        return Response.ok(
          jsonResponseEncode(operation.metadata),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to run trigger"}),
        );
      }
    } on Exception catch (e) {
      print(e);
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
