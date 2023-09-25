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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:cloud_provision_shared/catalog/models/build_details.dart';
import 'package:cloudprovision/modules/settings/data/project_provider.dart';

import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:cloudprovision/modules/my_services/data/services_repository.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';

import '../../auth/repositories/auth_provider.dart';
import '../data/build_repository.dart';
import '../../my_services/models/service.dart';
import '../data/build_service.dart';

part 'catalog_service.g.dart';

class CatalogService {
  CatalogService(this.ref);
  final Ref ref;

  Future<List<Template>> loadTemplates() {
    return Future.value(null);
  }

  Future<Template> templateById() {
    return Future.value(null);
  }

  Future<bool> deployTemplate(Template template,
      Map<String, String> templateParameters, String appId) async {

    bool isCICDenabled = false;

    template.inputs.forEach((element) {
      if (element.param == "_INSTANCE_GIT_REPO_OWNER") {
        isCICDenabled = true;
      }
    });

    GitSettings gitSettings =
        await ref.read(settingsRepositoryProvider).loadGitSettings();

    String projectId = ref.read(projectProvider).name;

    if (isCICDenabled) {
      templateParameters["_INSTANCE_GIT_REPO_OWNER"] =
          gitSettings.instanceGitUsername;
      templateParameters["_INSTANCE_GIT_REPO_TOKEN"] =
          gitSettings.instanceGitToken;
      templateParameters["_API_KEY"] = gitSettings.gcpApiKey;
    }
    templateParameters["_APP_ID"] = appId;

    try {

      final authRepo = ref.read(authRepositoryProvider);
      var authClient = await authRepo.getAuthClient();
      String accessToken = authClient.credentials.accessToken.data;

      BuildDetails buildDetails = await BuildRepository(buildService: BuildService.withAccessToken(accessToken))
          .deployTemplate(accessToken, projectId, template, templateParameters);

      if (buildDetails != "") {
        templateParameters["tags"] = template.tags.toString();

        final user = authRepo.currentUser()!;

        Service deployedService = Service(
            user: user.displayName!,
            userEmail: user.email!,
            serviceId: appId,
            name: templateParameters["_APP_NAME"]!,
            owner: gitSettings.instanceGitUsername,
            instanceRepo:
            "https://github.com/${templateParameters["_INSTANCE_GIT_REPO_OWNER"]}/${appId}",
            templateName: template.name,
            templateId: template.id,
            template: template,
            region: templateParameters["_REGION"]!,
            projectId: projectId,
            cloudBuildId: buildDetails.id,
            cloudBuildLogUrl: buildDetails.logUrl,
            params: templateParameters,
            deploymentDate: DateTime.now(),
            workstationCluster: templateParameters.containsKey("_WS_CLUSTER") &&
                templateParameters["_WS_CLUSTER"]! != "Select a cluster"
                ? templateParameters["_WS_CLUSTER"]!
                : "",
            workstationConfig: templateParameters.containsKey("_WS_CONFIG") &&
                templateParameters["_WS_CLUSTER"]! != "Select a cluster" &&
                templateParameters["_WS_CONFIG"]! != "Select a configuration"
                ? templateParameters["_WS_CONFIG"]!
                : "");

        await ref.read(servicesRepositoryProvider).addService(deployedService);

      } else {
        return false;
      }
    } on Error catch (e, stacktrace) {

      print("Error occurred: $e stackTrace: $stacktrace");
      return false;
    }

    return true;
  }
}

@riverpod
CatalogService catalogService(CatalogServiceRef ref) {
  return CatalogService(ref);
}