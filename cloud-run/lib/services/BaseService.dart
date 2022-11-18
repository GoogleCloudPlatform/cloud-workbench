import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';

class BaseService {
  late AuthClient client;

  BaseService() {
    getClient().then((value) => client = value);
  }

  Future<AuthClient> getClient() async {
    AuthClient client;

    if (Platform.isMacOS) {
      client = await clientViaApplicationDefaultCredentials(
          scopes: ["https://www.googleapis.com/auth/cloud-platform"]);
    } else {
      client = await clientViaMetadataServer();
    }

    return client;
  }
}
