import 'package:cloudprovision/repository/models/template.dart';

class Service {
  String? id;
  String serviceId;
  String name;
  String user;
  String userEmail;
  String owner;
  String instanceRepo;
  int templateId;
  String templateName;
  Template? template;
  String region;
  String projectId;
  String cloudBuildId;
  String cloudBuildLogUrl;
  DateTime deploymentDate;
  Map<String, dynamic> params;

  Service({
    required this.serviceId,
    required this.name,
    required this.user,
    required this.userEmail,
    required this.owner,
    required this.instanceRepo,
    required this.templateId,
    required this.templateName,
    required this.template,
    required this.region,
    required this.projectId,
    required this.cloudBuildId,
    required this.cloudBuildLogUrl,
    required this.params,
    required this.deploymentDate,
  });

  Service.fromJson(Map<String, dynamic> parsedJson)
      : serviceId =
            parsedJson['serviceId'] == null ? "" : parsedJson['serviceId'],
        name = parsedJson['name'],
        user = parsedJson['user'] == null ? "" : parsedJson['user'],
        userEmail =
            parsedJson['userEmail'] == null ? "" : parsedJson['userEmail'],
        owner = parsedJson['owner'],
        instanceRepo = parsedJson['instanceRepo'],
        templateId = parsedJson['templateId'],
        templateName = parsedJson['templateName'],
        template = parsedJson['template'] == null
            ? null
            : Template.fromJson(parsedJson['template']),
        region = parsedJson['region'],
        projectId = parsedJson['projectId'],
        cloudBuildId = parsedJson['cloudBuildId'],
        cloudBuildLogUrl = parsedJson.containsKey('cloudBuildLogUrl')
            ? parsedJson['cloudBuildLogUrl']
            : "",
        params = parsedJson['params'],
        deploymentDate = DateTime.parse(parsedJson['deploymentDate'] as String);

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'name': name,
      'user': user,
      'userEmail': userEmail,
      'owner': owner,
      'instanceRepo': instanceRepo,
      'templateId': templateId,
      'templateName': templateName,
      'template': template!.toJson(),
      'region': region,
      'projectId': projectId,
      'cloudBuildId': cloudBuildId,
      'cloudBuildLogUrl': cloudBuildLogUrl,
      'params': params,
      'deploymentDate': deploymentDate.toIso8601String(),
    };
  }
}
