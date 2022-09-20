import 'dart:convert';

import 'package:cloud_provision_server/models/template_model.dart';
import 'package:http/http.dart' as http;

class TemplatesService {
  // TODO: Read/inject URI from configuration
  final String templatesUri =
      "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json";

  /// Returns list of solution templates
  Future<List<TemplateModel>> getTemplates() async {
    final http.Client client = new http.Client();
    var response = await client.get(Uri.parse(templatesUri));

    Iterable templateList = json.decode(response.body);
    List<TemplateModel> templates = List<TemplateModel>.from(
        templateList.map((model) => TemplateModel.fromJson(model)));

    return templates;
  }
}
