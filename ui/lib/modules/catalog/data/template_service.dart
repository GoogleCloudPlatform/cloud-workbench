import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_provision_shared/catalog/models/template.dart';
import '../../../shared/service/base_service.dart';

class TemplateService extends BaseService {
  Future<List<Template>> loadTemplates(
      String catalogSource, String catalogUrl) async {
    var endpointPath = '/v1/templates';

    final queryParameters = {
      'catalogSource': catalogSource,
      'catalogUrl': catalogUrl,
    };

    var url = getUrl(endpointPath, queryParameters: queryParameters);

    Map<String, String> requestHeaders = await getRequestHeaders();

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

    Map<String, String> requestHeaders = await getRequestHeaders();

    var response = await http
        .get(url, headers: requestHeaders)
        .timeout(Duration(seconds: 10));

    Template template = Template.fromJson(json.decode(response.body));

    return template;
  }
}
