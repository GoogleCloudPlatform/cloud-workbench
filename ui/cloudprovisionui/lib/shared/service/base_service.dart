import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class BaseService {
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
    var identityToken = await user.getIdToken();

      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      return requestHeaders;
  }
}
