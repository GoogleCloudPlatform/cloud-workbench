class Param {
  String param;
  String label;
  String description;
  String type;
  bool required;
  bool? display;

  Param(this.param, this.label, this.description, this.type, this.required);

  Param.fromJson(Map<String, dynamic> parsedJson)
      : param = parsedJson['param'],
        label = parsedJson['label'],
        description = parsedJson['description'],
        type = parsedJson['type'],
        required = parsedJson['required'],
        display = parsedJson['display'] == null ? true : parsedJson['display'];

  Map<String, dynamic> toJson() {
    return {
      'param': param,
      'label': label,
      'description': description,
      'type': type,
      'required': required,
      'display': display == null ? true : display,
    };
  }
}
