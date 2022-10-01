class Service {
  String? id;
  String name;
  String owner;
  String templateName;
  String instanceRepo;
  String region;
  String projectId;
  DateTime deploymentDate;

  Service(
    this.name,
    this.owner,
    this.templateName,
    this.instanceRepo,
    this.region,
    this.projectId,
    this.deploymentDate,
  );

  Service.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        owner = parsedJson['owner'],
        templateName = parsedJson['templateName'],
        instanceRepo = parsedJson['instanceRepo'],
        region = parsedJson['region'],
        projectId = parsedJson['projectId'],
        deploymentDate = DateTime.parse(parsedJson['deploymentDate'] as String);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'templateName': templateName,
      'instanceRepo': instanceRepo,
      'region': region,
      'projectId': projectId,
      'deploymentDate': deploymentDate.toIso8601String(),
    };
  }
}
