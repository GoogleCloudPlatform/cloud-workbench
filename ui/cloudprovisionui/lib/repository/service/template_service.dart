import 'dart:convert';
import 'dart:io';

import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/repository/service/base_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class TemplateService extends BaseService {
  Future<List<Template>> loadTemplates() async {
    var endpointPath = '/v1/templates';
    var url = Uri.https(cloudProvisionServerUrl, endpointPath);
    if (cloudProvisionServerUrl.contains("localhost")) {
      url = Uri.http(cloudProvisionServerUrl, endpointPath);
    }

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http.get(url, headers: requestHeaders);

    Iterable l = json.decode(response.body);
    List<Template> templates =
        List<Template>.from(l.map((model) => Template.fromJson(model)));

    return templates;
  }

  Future<Template> loadTemplateById(int templateId) async {
    var endpointPath = '/v1/templates';
    final queryParameters = {
      'templateId': templateId.toString(),
    };

    var url = Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);
    if (cloudProvisionServerUrl.contains("localhost")) {
      url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
    }

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http.get(url, headers: requestHeaders);

    Template template = Template.fromJson(json.decode(response.body));

    return template;
  }
}
