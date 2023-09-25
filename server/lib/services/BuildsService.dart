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

import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;

import 'ConfigService.dart';

class BuildsService extends BaseService {
  ConfigService _configService = ConfigService();
  /// Returns Cloud Build details for specified parameters
  ///
  /// [projectId]
  /// [buildId]
  Future<cb.Build> getBuildDetails(projectId, buildId) async {
    var cloudBuildApi = cb.CloudBuildApi(client);

    cb.Build build =
        await cloudBuildApi.projects.builds.get(projectId, buildId);

    return build;
  }

  /// Starts Cloud Build build for specified configuration
  ///
  /// [projectId]
  /// [substitutionsMap]
  /// [cloudProvisionJsonConfig]
  Future<cb.Operation> startBuild(String accessToken,
      projectId, substitutionsMap, templateConfigUrl, String method) async {

    Map<String, dynamic> templateJsonConfig =
    await _configService.getJson(templateConfigUrl);

    var templateBuildSteps = templateJsonConfig['create']['steps'];
    if (method == "DELETE")
       templateBuildSteps = templateJsonConfig['destroy']['steps'];

    String parent = "projects/${projectId}/locations/global";

    List<cb.BuildStep> buildSteps = [];

    for (Map<dynamic, dynamic> jsonStep in templateBuildSteps) {
      var buildStep = cb.BuildStep.fromJson(jsonStep);
      buildSteps.add(buildStep);
    }

    cb.BuildOptions buildOptions = cb.BuildOptions();
    buildOptions.substitutionOption = 'ALLOW_LOOSE';

    var buildRequest = cb.Build(
        substitutions: substitutionsMap,
        steps: buildSteps,
        options: buildOptions);

    var cloudBuildApi = cb.CloudBuildApi(getAuthenticatedClient(accessToken));
    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    return buildOp;
  }
}
