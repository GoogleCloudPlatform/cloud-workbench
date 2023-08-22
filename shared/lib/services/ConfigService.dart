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
