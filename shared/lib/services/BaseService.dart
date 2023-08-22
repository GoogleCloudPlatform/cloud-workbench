import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart' as http;

class BaseService {

  final String accessToken;

  BaseService(this.accessToken);

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

  AuthClient getAuthenticatedClient() {
    var authenticatedClient = gapis.authenticatedClient(
        http.Client(), getCredentials(accessToken));

    return authenticatedClient;
  }

  // AuthClient getClientFromContext(Object context, String authType) {
  // return client that is initialized based on the context
  // }

}
