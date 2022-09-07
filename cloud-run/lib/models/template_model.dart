// TODO
// add description and other fields, ex required user input fields like project id, etc.
import 'dart:convert';

import 'package:cloud_provision_server/models/param_model.dart';

class TemplateModel {
  int id;
  String name;
  String description;
  String sourceUrl;
  List<ParamModel> params;
  TemplateModel(
      this.id, this.name, this.description, this.sourceUrl, this.params);

  TemplateModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        sourceUrl = parsedJson['sourceUrl'],
        params = parsedJson['params'] == null
            ? []
            : (parsedJson['params'] as List)
                .map((i) => ParamModel.fromJson(i))
                .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceUrl': sourceUrl,
      'params': jsonEncode(params),
    };
  }
}
