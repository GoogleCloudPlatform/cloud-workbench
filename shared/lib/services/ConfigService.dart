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

import 'package:http/http.dart' as http;

class ConfigService {
  /// Returns JSON document
  ///
  /// [jsonDocUrl]
  Future<Map<String, dynamic>> getJson(String jsonDocUrl) async {
    final http.Client client = new http.Client();
    var response = await client
        .get(Uri.parse(jsonDocUrl))
        .timeout(const Duration(seconds: 30));
    return json.decode(response.body);
  }
}
