class Service {
  String? id;
  String name;
  String owner;
  String instanceRepo;
  int templateId;
  String templateName;
  String region;
  String projectId;
  String cloudBuildId;
  DateTime deploymentDate;
  Map<String, dynamic> params;

  Service({
    required this.name,
    required this.owner,
    required this.instanceRepo,
    required this.templateId,
    required this.templateName,
    required this.region,
    required this.projectId,
    required this.cloudBuildId,
    required this.params,
    required this.deploymentDate,
  });

  Service.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        owner = parsedJson['owner'],
        instanceRepo = parsedJson['instanceRepo'],
        templateId = parsedJson['templateId'],
        templateName = parsedJson['templateName'],
        region = parsedJson['region'],
        projectId = parsedJson['projectId'],
        cloudBuildId = parsedJson['cloudBuildId'],
        params = parsedJson['params'],
        deploymentDate = DateTime.parse(parsedJson['deploymentDate'] as String);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'instanceRepo': instanceRepo,
      'templateId': templateId,
      'templateName': templateName,
      'region': region,
      'projectId': projectId,
      'cloudBuildId': cloudBuildId,
      'params': params,
      'deploymentDate': deploymentDate.toIso8601String(),
    };
  }
}
