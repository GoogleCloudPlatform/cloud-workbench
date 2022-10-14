class TemplateMetadata {
  String name;
  String value;
  String type;

  TemplateMetadata(this.name, this.value, this.type);

  TemplateMetadata.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        value = parsedJson['value'],
        type = parsedJson['type'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'type': type,
    };
  }
}
