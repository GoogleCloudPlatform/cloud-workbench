import 'dart:convert';
import 'dart:io';

import 'package:cloudprovision/models/template_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var cloudRunUrl = dotenv.get('CLOUD_PROVISION_API_URL');

class TemplateRepository {
  Future<List<TemplateModel>> loadTemplates() async {
    var endpointPath = '/v1/templates';
    var url = Uri.https(cloudRunUrl, endpointPath);
    if (cloudRunUrl.contains("localhost")) {
      url = Uri.http(cloudRunUrl, endpointPath);
    }

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http.get(url, headers: requestHeaders);

    Iterable l = json.decode(response.body);
    List<TemplateModel> templates = List<TemplateModel>.from(
        l.map((model) => TemplateModel.fromJson(model)));

    return templates;
  }

  Future<TemplateModel> loadTemplateById(int templateId) async {
    var endpointPath = '/v1/templates';
    final queryParameters = {
      'templateId': "4",
    };

    var url = Uri.https(cloudRunUrl, endpointPath, queryParameters);
    if (cloudRunUrl.contains("localhost")) {
      url = Uri.http(cloudRunUrl, endpointPath, queryParameters);
    }

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http.get(url, headers: requestHeaders);

    TemplateModel template = TemplateModel.fromJson(json.decode(response.body));

    return template;
  }
}
