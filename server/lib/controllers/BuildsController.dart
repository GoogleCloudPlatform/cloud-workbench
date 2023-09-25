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

      var accessToken = requestMap['accessToken'];
      var projectId = requestMap['project_id'];
      var templateConfigUrl = requestMap['cloudProvisionConfigUrl'];
      Map<String, String> substitutionsMap =
          Map<String, String>.from(requestMap['params']);

      cb.Operation buildOp = await _buildsService.startBuild(accessToken,
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
