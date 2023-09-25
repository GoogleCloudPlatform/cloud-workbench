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

import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloudprovision/shared/service/base_service.dart';

class ProjectRepository extends BaseService {

  ProjectRepository(String accessToken) :
        super.withAccessToken(accessToken);

  var services = [
    "cloudbuild.googleapis.com",
    "workstations.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "recommender.googleapis.com",
    "containerscanning.googleapis.com",
  ];

  enableServices(String projectId) async {
    ProjectService projectService = new ProjectService(accessToken);

    services.forEach((serviceName) async {
      await projectService.enableService(projectId, serviceName);
    });
  }

  verifyServices(String projectId) {
    ProjectService projectService = new ProjectService(accessToken);

    services.forEach((serviceName) async {
      bool state = await projectService.isServiceEnabled(projectId, serviceName);
      print("${serviceName} - enabled = ${state}");
    });
  }

  Future<bool> verifyService(String projectId, String serviceName) async {
    ProjectService projectService = new ProjectService(accessToken);
    bool state = await projectService.isServiceEnabled(projectId, serviceName);
    return state;
  }

  createArtifactRegistry(String projectId, String region, String name,
      String format) async {
    ProjectService projectService = new ProjectService(accessToken);
    await projectService.createArtifactRegistry(projectId, region, name, format);
  }

  grantRoles(String projectId, String projectNumber) async {
    ProjectService projectService = new ProjectService(accessToken);
    await projectService.grantRoles(projectId, projectNumber);
  }
}