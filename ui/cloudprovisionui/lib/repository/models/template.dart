import 'package:cloudprovision/repository/models/param.dart';

class Template {
  int id;
  String name;
  String description;
  String sourceUrl;
  String cloudProvisionConfigUrl;
  List<Param> params;

  Template(this.id, this.name, this.description, this.sourceUrl,
      this.cloudProvisionConfigUrl, this.params);

  Template.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        sourceUrl = parsedJson['sourceUrl'],
        cloudProvisionConfigUrl = parsedJson['cloudProvisionConfigUrl'],
        params = parsedJson['params'] == null
            ? []
            : (parsedJson['params'] as List)
                .map((i) => Param.fromJson(i))
                .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceUrl': sourceUrl,
      'cloudProvisionConfigUrl': cloudProvisionConfigUrl,
      'params': params,
    };
  }
}
