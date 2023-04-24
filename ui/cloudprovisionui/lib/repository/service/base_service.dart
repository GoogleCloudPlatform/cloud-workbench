import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseService {
  static const String cloudProvisionServerUrl = String.fromEnvironment('CLOUD_PROVISION_API_URL', defaultValue: "");

  Uri getUrl(String endpointPath, {Map<String, dynamic>? queryParameters}) {
    var url = Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);

    if (cloudProvisionServerUrl.contains("localhost")) {
      url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
    }

    return url;
  }
}
