import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:dotenv/dotenv.dart';

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
}
