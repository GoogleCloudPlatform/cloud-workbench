import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:cloud_provision_shared/services/TemplatesService.dart' as sharedService;
import '../../../shared/service/base_service.dart';

class TemplateService extends BaseService {

  Future<List<Template>> loadTemplates() async {

    List<Template> templates = [];

    if (serverEnabled) {
      var endpointPath = '/v1/templates';

      final queryParameters = {
        'catalogSource': 'catalogSource',
        'catalogUrl': 'catalogUrl',
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      Map<String, String> requestHeaders = await getRequestHeaders();

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);

      templates = List<Template>
          .from(l.map((model) => Template.fromJson(model)));
    } else {
      sharedService.TemplatesService templatesService = new sharedService
          .TemplatesService();
      templates = await templatesService.getTemplates();
    }

    return templates;
  }

  Future<Template> loadTemplateById(
      int templateId, String catalogSource) async {

    Template? template;

    if (serverEnabled) {
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

      template = Template.fromJson(json.decode(response.body));
    } else {
      sharedService.TemplatesService templatesService = new sharedService
          .TemplatesService();
      template = await templatesService.getTemplateById(templateId, catalogSource);
    }

    return template!;
  }
}
