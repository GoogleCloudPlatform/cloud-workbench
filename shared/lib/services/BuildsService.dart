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

import 'package:googleapis/cloudbuild/v1.dart' as cb;

import '../catalog/models/build_details.dart';
import 'BaseService.dart';
import 'ConfigService.dart';

class BuildsService extends BaseService {
  BuildsService(String accessToken) : super(accessToken);

  ConfigService _configService = ConfigService();

  /// Returns Cloud Build details for specified parameters
  ///
  /// [projectId]
  /// [buildId]
  Future<cb.Build> getBuildDetails(projectId, buildId) async {
    var cloudBuildApi = cb.CloudBuildApi(null!);

    cb.Build build =
        await cloudBuildApi.projects.builds.get(projectId, buildId);

    return build;
  }

  /// Returns Cloud Build build request
  ///
  /// [templateJsonConfig]
  /// [method]
  /// [substitutionsMap]
  Future<cb.Build> getBuildRequest(Map<String, dynamic> templateJsonConfig,
      String method, substitutionsMap) async {
    var templateBuildSteps = templateJsonConfig['create']['steps'];

    if (method == "DELETE") {
      templateBuildSteps = templateJsonConfig['destroy']['steps'];
    }

    List<cb.BuildStep> buildSteps = [];

    for (Map<dynamic, dynamic> jsonStep in templateBuildSteps) {
      var buildStep = cb.BuildStep.fromJson(jsonStep);
      buildSteps.add(buildStep);
    }

    cb.BuildOptions buildOptions = cb.BuildOptions();
    buildOptions.substitutionOption = 'ALLOW_LOOSE';

    return cb.Build(
        substitutions: substitutionsMap,
        steps: buildSteps,
        options: buildOptions);
  }

  /// Starts Cloud Build build for specified configuration
  ///
  /// [projectId]
  /// [substitutionsMap]
  /// [cloudProvisionJsonConfig]
  Future<BuildDetails> startBuild(
      projectId, substitutionsMap, templateConfigUrl, String method) async {
    Map<String, dynamic> templateJsonConfig =
        await _configService.getJson(templateConfigUrl);

    var buildRequest = await this
        .getBuildRequest(templateJsonConfig, method, substitutionsMap);

    String parent = "projects/${projectId}/locations/global";

    var cloudBuildApi = cb.CloudBuildApi(getAuthenticatedClient());
    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    Map<String, dynamic> details = Map.from(buildOp.metadata?['build']! as Map);

    return new BuildDetails(
        details["id"] as String, details["logUrl"] as String);
  }
}
