import 'dart:convert';

import 'package:cloud_provision_server/models/param_model.dart';
import 'package:cloud_provision_server/models/template_model.dart';
import 'package:cloud_provision_server/services/ConfigService.dart';
import 'package:http/http.dart' as http;

class TemplatesService {
  ConfigService _configService = ConfigService();

  // TODO: Read/inject URI from configuration
  final String templatesUri =
      "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates-v2.json";

  /// Returns list of solution templates
  Future<List<TemplateModel>> getTemplates() async {
    final http.Client client = new http.Client();
    var response = await client.get(Uri.parse(templatesUri));

    Iterable templateList = json.decode(response.body);
    List<TemplateModel> templates = List<TemplateModel>.from(
        templateList.map((model) => TemplateModel.fromJson(model)));

    return templates;
  }

  Future<TemplateModel?> getTemplateById(int templateId) async {
    final http.Client client = new http.Client();
    var response = await client.get(Uri.parse(templatesUri));

    Iterable templateList = json.decode(response.body);
    List<TemplateModel> templates = List<TemplateModel>.from(
        templateList.map((model) => TemplateModel.fromJson(model)));

    List<TemplateModel> templateL =
        templates.where((element) => element.id == templateId).toList();

    TemplateModel template;
    if (templateL.isEmpty) {
      return null;
    }
    template = templateL.first;

    Map<String, dynamic> cloudProvisionJsonConfig =
        await _configService.getJson(template.cloudProvisionConfigUrl);

    Iterable paramsList = cloudProvisionJsonConfig['params'];
    List<ParamModel> params = List<ParamModel>.from(
        paramsList.map((model) => ParamModel.fromJson(model)));

    template.params = params;

    return template;
  }
}
