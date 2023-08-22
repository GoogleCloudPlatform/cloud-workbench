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

  /// Starts Cloud Build build for specified configuration
  ///
  /// [projectId]
  /// [substitutionsMap]
  /// [cloudProvisionJsonConfig]
  Future<BuildDetails> startBuild(
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

    var cloudBuildApi = cb.CloudBuildApi(getAuthenticatedClient());
    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    Map<String, dynamic> details = Map.from(buildOp.metadata?['build']! as Map);

    return new BuildDetails(details["id"] as String,
        details["logUrl"] as String);
  }
}
