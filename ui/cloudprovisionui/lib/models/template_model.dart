// TODO
// add description and other fields, ex required user input fields like project id, etc.
class TemplateModel {
  int id;
  String name;
  // String description;
  String gitUrl;
  TemplateModel(this.id, this.name, /*this.description,*/ this.gitUrl);

  TemplateModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        // description = parsedJson['description'],
        gitUrl = parsedJson['git'];
}
