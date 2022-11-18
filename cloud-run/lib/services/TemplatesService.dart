import 'dart:convert';

import 'package:cloud_provision_server/models/param_model.dart';
import 'package:cloud_provision_server/models/template_model.dart';
import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:cloud_provision_server/services/ConfigService.dart';
import 'package:http/http.dart' as http;

class TemplatesService extends BaseService {
  ConfigService _configService = ConfigService();

  // TODO: Read/inject URI from configuration
  String templatesUri =
      "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json";

  String communityCatalogUrl =
      "https://raw.githubusercontent.com/gitrey/community-templates/main/templates.json";

  /// Returns list of solution templates
  Future<List<Template>> getTemplates(
      String catalogSource, String catalogUrl) async {
    final http.Client client = new http.Client();

    var catalogUrl = templatesUri;
    if (catalogSource == "community") {
      catalogUrl = communityCatalogUrl;
    } else if (catalogSource == "customer") {
      catalogUrl = "";
      return [];
    }

    var response = await client.get(Uri.parse(catalogUrl));

    Iterable templateList = json.decode(response.body);
    List<Template> templates = List<Template>.from(
        templateList.map((model) => Template.fromJson(model)));

    return templates;
  }

  Future<Template?> getTemplateById(
      int templateId, String catalogSource) async {
    final http.Client client = new http.Client();

    var catalogUrl = templatesUri;
    if (catalogSource == "community") {
      catalogUrl = communityCatalogUrl;
    } else if (catalogSource == "customer") {
      catalogUrl = "";
      return null;
    }

    var response = await client.get(Uri.parse(catalogUrl));

    Iterable templateList = json.decode(response.body);
    List<Template> templates = List<Template>.from(
        templateList.map((model) => Template.fromJson(model)));

    List<Template> templateL =
        templates.where((element) => element.id == templateId).toList();

    Template template;
    if (templateL.isEmpty) {
      return null;
    }
    template = templateL.first;

    Map<String, dynamic> cloudProvisionJsonConfig =
        await _configService.getJson(template.cloudProvisionConfigUrl);

    Iterable paramsList = cloudProvisionJsonConfig['inputs'];
    List<Param> params =
        List<Param>.from(paramsList.map((model) => Param.fromJson(model)));

    template.inputs = params;

    return template;
  }
}
