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
