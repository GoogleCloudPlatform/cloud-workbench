import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/template.dart';
import '../../../repository/service/base_service.dart';

class TemplateService extends BaseService {
  Future<List<Template>> loadTemplates(
      String catalogSource, String catalogUrl) async {
    var endpointPath = '/v1/templates';

    final queryParameters = {
      'catalogSource': catalogSource,
      'catalogUrl': catalogUrl,
    };

    var url = getUrl(endpointPath, queryParameters: queryParameters);

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http
        .get(url, headers: requestHeaders)
        .timeout(Duration(seconds: 10));

    Iterable l = json.decode(response.body);
    List<Template> templates =
        List<Template>.from(l.map((model) => Template.fromJson(model)));

    return templates;
  }

  Future<Template> loadTemplateById(
      int templateId, String catalogSource) async {
    var endpointPath = '/v1/templates';
    final queryParameters = {
      'templateId': templateId.toString(),
      'catalogSource': catalogSource,
    };

    var url = getUrl(endpointPath, queryParameters: queryParameters);

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http
        .get(url, headers: requestHeaders)
        .timeout(Duration(seconds: 10));

    Template template = Template.fromJson(json.decode(response.body));

    return template;
  }
}
