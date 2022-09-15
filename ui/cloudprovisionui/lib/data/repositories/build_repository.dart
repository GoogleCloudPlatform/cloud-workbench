import 'dart:convert';

import 'package:cloudprovision/models/template_model.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// TODO set it during startup in Dockerfile
// const cloudRunUrl = String.fromEnvironment('CLOUD_PROVISION_SERVICE_URL');
const cloudRunUrl = "cloud-provision-server-4mizdq5szq-ue.a.run.app";

class BuildRepository {
  Future<String> deployTemplate(String projectId, TemplateModel template,
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

      var url = Uri.https(cloudRunUrl, endpointPath);

      var body = json.encode({
        "project_id": projectId,
        "template_id": "${template.id}",
        "params": formFieldValuesMap
      });

      var response = await http.post(url, headers: requestHeaders, body: body);

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

      var url = Uri.https(cloudRunUrl, endpointPath, queryParameters);

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

      var url = Uri.https(cloudRunUrl, endpointPath);

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
