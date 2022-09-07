import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart";

void main() async {
  AccessCredentials ac = await obtainCredentials();

  var token = ac.accessToken.type + " " + ac.accessToken.data;

  Map<String, String> tokenRequestHeaders = {
    HttpHeaders.authorizationHeader: token,
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
  };

  var tokenAuthority = "iamcredentials.googleapis.com";
  // service account: cloud-provision@projectid.iam.gserviceaccount.com
  var tokenPath =
      "/v1/projects/-/serviceAccounts/cloud-provision@projectid.iam.gserviceaccount.com:generateIdToken";

  var iamCredentialsUrl = Uri.https(tokenAuthority, tokenPath);

  var cloudRunUrl = "cloud-provision-service-ue.a.run.app";
  var endpointPath = '/test';

  var tokenRequestBody =
      '{"audience": "https://${cloudRunUrl}\","includeEmail": "true"}';
  var tokenResponse = await http.post(iamCredentialsUrl,
      headers: tokenRequestHeaders, body: tokenRequestBody);

  Map<String, dynamic> responseBody = jsonDecode(tokenResponse.body);

  Map<String, String> requestHeaders = {
    HttpHeaders.authorizationHeader: "Bearer " + responseBody['token']
  };

  var url = Uri.https(cloudRunUrl, endpointPath);

  var response = await http.get(url, headers: requestHeaders);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

Future<AccessCredentials> obtainCredentials() async {
  var jsonCredentials = new File('cp.json').readAsStringSync();
  var accountCredentials =
      new ServiceAccountCredentials.fromJson(jsonCredentials);

  var scopes = ["https://www.googleapis.com/auth/cloud-platform"];

  var client = http.Client();
  AccessCredentials credentials =
      await obtainAccessCredentialsViaServiceAccount(
          accountCredentials, scopes, client);

  client.close();
  return credentials;
}
