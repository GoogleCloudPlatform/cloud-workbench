import 'package:cloudprovision/repository/service/base_service.dart';
import 'dart:convert';

import 'package:cloudprovision/repository/models/template.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class BuildService extends BaseService {
  Future<String> deployTemplate(String projectId, Template template,
      Map<String, dynamic> formFieldValuesMap) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    String result = "";

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/builds';

      var url = Uri.https(cloudProvisionServerUrl, endpointPath);

      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath);
      }

      var body = json.encode({
        "project_id": projectId,
        "template_id": "${template.id}",
        "params": formFieldValuesMap
      });

      var response = await http.post(url, headers: requestHeaders, body: body);

      if (response.statusCode == 500) {
        return result;
      }

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> getBuildDetails(String projectId, String buildId) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    String result = "";

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/builds';
      // could be passed as request params
      final queryParameters = {
        'projectId': projectId,
        'buildId': buildId,
      };

      var url =
          Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);
      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
      }
      var response = await http.get(url, headers: requestHeaders);

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> runTrigger(String projectId, String appName) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    String result = "";

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/triggers';

      var url = Uri.https(cloudProvisionServerUrl, endpointPath);
      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath);
      }

      var body = json.encode({
        "project_id": projectId,
        "app_name": appName,
      });

      var response = await http.post(url, headers: requestHeaders, body: body);

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;
  }
}
