import 'package:cloud_provision_server/models/param_model.dart';

class Template {
  int id;
  String name;
  String description;
  String sourceUrl;
  String cloudProvisionConfigUrl;
  String version;
  String category;
  DateTime lastModified;
  String owner;
  String email;
  List<String> tags;
  List<Param> params;

  Template(
      this.id,
      this.name,
      this.description,
      this.sourceUrl,
      this.cloudProvisionConfigUrl,
      this.params,
      this.version,
      this.category,
      this.tags,
      this.lastModified,
      this.owner,
      this.email);

  Template.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        sourceUrl = parsedJson['sourceUrl'],
        cloudProvisionConfigUrl = parsedJson['cloudProvisionConfigUrl'],
        version = parsedJson['version'],
        category = parsedJson['category'],
        lastModified = DateTime.parse(parsedJson['lastModified'] as String),
        owner = parsedJson['owner'],
        email = parsedJson['email'],
        tags = (parsedJson['tags'] as List<dynamic>).cast<String>(),
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
      'version': version,
      'category': category,
      'lastModified': lastModified.toIso8601String(),
      'owner': owner,
      'email': email,
      'tags': tags,
      'params': params,
    };
  }
}
