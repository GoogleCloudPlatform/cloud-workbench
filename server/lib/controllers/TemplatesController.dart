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
