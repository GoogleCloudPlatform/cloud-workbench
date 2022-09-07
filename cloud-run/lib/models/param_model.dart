class ParamModel {
  String param;
  String label;
  String description;
  String type;
  bool required;

  ParamModel(
      this.param, this.label, this.description, this.type, this.required);

  ParamModel.fromJson(Map<String, dynamic> parsedJson)
      : param = parsedJson['param'],
        label = parsedJson['label'],
        description = parsedJson['description'],
        type = parsedJson['type'],
        required = parsedJson['required'];

  Map<String, dynamic> toJson() {
    return {
      'param': param,
      'label': label,
      'description': description,
      'type': type,
      'required': required,
    };
  }
}
