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

import 'dart:io';

import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'dart:convert';

class EnvController extends BaseController {

  Router get router {
    final router = Router();
    router.get('/', _getEnvHandler);

    return router;
  }

  static const String firebaseConfigVar = "FIREBASE_CONFIG";

  Future<Response> _getEnvHandler(Request request) async {
    var firebaseConfig = {
      firebaseConfigVar: Platform.environment[firebaseConfigVar]
    };

    return Response.ok(jsonEncode(firebaseConfig));
  }
}
