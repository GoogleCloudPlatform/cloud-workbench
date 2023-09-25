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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseService {

  bool serverEnabled = dotenv.get("SERVER_ENABLED", fallback: "false") == "true";

  late String accessToken;

  BaseService() {
    accessToken = "test token";
  }

  BaseService.withAccessToken(String token) {
    accessToken = token;
  }

  static const String cloudProvisionServerUrl = String.fromEnvironment('CLOUD_PROVISION_API_URL', defaultValue: "");

  Uri getUrl(String endpointPath, {Map<String, dynamic>? queryParameters}) {
    var url = Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);

    if (cloudProvisionServerUrl.contains("localhost")) {
      url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
    }

    return url;
  }

  Future<Map<String, String>> getRequestHeaders() async {
    final user = FirebaseAuth.instance.currentUser!;
    String? identityToken = await user.getIdToken();

      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken!,
        HttpHeaders.contentTypeHeader: "application/json",
        "Access-token": accessToken
      };

      return requestHeaders;
  }
}
