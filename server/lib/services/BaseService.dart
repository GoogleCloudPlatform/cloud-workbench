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

import 'package:googleapis_auth/auth_io.dart';
import 'package:dotenv/dotenv.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart' as http;

class BaseService {
  var _env = DotEnv(includePlatformEnvironment: true)
    ..load(["/app/bin/config/env", "./config/env"]);
  late AutoRefreshingAuthClient client;

  BaseService() {
    getClient().then((value) => client = value);
  }

  Future<AutoRefreshingAuthClient> getClient() async {

    AutoRefreshingAuthClient client;

    if (Platform.isMacOS) {
      client = await clientViaApplicationDefaultCredentials(
          scopes: ["https://www.googleapis.com/auth/cloud-platform"]);
    } else {
      client = await clientViaMetadataServer();
    }

    return client;
  }

  bool isEnvVarSet(String varName) {
    return _env.isDefined(varName);
  }

  String? getEnvVar(String varName) {
    return _env[varName];
  }


  gapis.AccessCredentials getCredentials(String accessToken) {
    final gapis.AccessCredentials credentials = gapis.AccessCredentials(
      gapis.AccessToken(
        'Bearer',
        accessToken,
        DateTime.now().toUtc().add(const Duration(days: 365)),
      ),
      null, // We don't have a refreshToken
      ["https://www.googleapis.com/auth/cloud-platform"],
    );

    return credentials;
  }

  AuthClient getAuthenticatedClient(String accessToken) {
    var authenticatedClient = gapis.authenticatedClient(
        http.Client(), getCredentials(accessToken));

    return authenticatedClient;
  }

  // AuthClient getClientFromContext(Object context, String authType) {
  // return client that is initialized based on the context
  // }

}
