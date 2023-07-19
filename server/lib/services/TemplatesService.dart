import 'dart:convert';

import 'package:cloud_provision_shared/catalog/models/param.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:cloud_provision_server/services/ConfigService.dart';
import 'package:http/http.dart' as http;

class TemplatesService extends BaseService {
  ConfigService _configService = ConfigService();

  String _getCatalogUrl(String catalogSource) {
    var catalogUrl = getEnvVar("GCP_CATALOG_URL")!;
    if (catalogSource == "community") {
      catalogUrl = getEnvVar("COMMUNITY_CATALOG_URL")!;
    } else if (catalogSource == "customer") {
      catalogUrl = "";
    }
    return catalogUrl;
  }

  /// Returns list of solution templates
  Future<List<Template>> getTemplates(
      String catalogSource, String catalogUrl) async {
    final http.Client client = new http.Client();

    // TODO: add logic to handle private catalog
    if (catalogSource == "customer") {
      return [];
    }

    var catalogUrl = _getCatalogUrl(catalogSource);

    var response = await client.get(Uri.parse(catalogUrl));

    Iterable templateList = json.decode(response.body);
    List<Template> templates = List<Template>.from(
        templateList.map((model) => Template.fromJson(model)));

    return templates;
  }

  Future<Template?> getTemplateById(
      int templateId, String catalogSource) async {
    final http.Client client = new http.Client();

    // TODO: add logic to handle private catalog
    if (catalogSource == "customer") {
      return null;
    }

    var catalogUrl = _getCatalogUrl(catalogSource);

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
