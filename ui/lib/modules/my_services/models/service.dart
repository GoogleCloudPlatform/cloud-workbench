// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_provision_shared/catalog/models/template.dart';

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
  String workstationCluster;
  String workstationConfig;

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
    required this.workstationCluster,
    required this.workstationConfig,
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
        workstationCluster = parsedJson['workstationCluster'] != null
            ? parsedJson['workstationCluster']
            : "",
        workstationConfig = parsedJson['workstationConfig'] != null
            ? parsedJson['workstationConfig']
            : "",
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
      'workstationCluster': workstationCluster,
      'workstationConfig': workstationConfig,
    };
  }
}
