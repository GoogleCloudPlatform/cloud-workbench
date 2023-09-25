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

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../shared/service/base_service.dart';

class RuntimeEnvClient extends BaseService {
  static const String firebaseConfigVar = "FIREBASE_CONFIG";

  static dynamic getEnvVars({String url = "/"}) async {
    BaseService baseService = new BaseService();

    try {
      var response = await http.get(baseService.getUrl(url));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey(firebaseConfigVar)) {
          String fixedJsonString =
              jsonResponse[firebaseConfigVar].replaceAllMapped(
            RegExp(r'(\w+): '),
            (match) => '"${match.group(1)}": ',
          );

          jsonResponse[firebaseConfigVar] = jsonDecode(fixedJsonString);
        }

        return jsonResponse;
      }
    } catch (e) {
      log(e.toString());
    }
    return "";
  }
}
