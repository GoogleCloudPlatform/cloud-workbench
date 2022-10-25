import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;

class BuildsService {
  /// Returns Cloud Build details for specified parameters
  ///
  /// [projectId]
  /// [buildId]
  Future<cb.Build> getBuildDetails(projectId, buildId) async {
    AuthClient client = await clientViaMetadataServer();
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
  Future<cb.Operation> startBuild(
      projectId, substitutionsMap, cloudProvisionJsonConfig) async {
    String parent = "projects/${projectId}/locations/global";

    List<cb.BuildStep> buildSteps = [];

    for (Map<dynamic, dynamic> jsonStep in cloudProvisionJsonConfig) {
      var buildStep = cb.BuildStep.fromJson(jsonStep);
      buildSteps.add(buildStep);
    }

    cb.BuildOptions buildOptions = cb.BuildOptions();
    buildOptions.substitutionOption = 'ALLOW_LOOSE';

    var buildRequest = cb.Build(
        substitutions: substitutionsMap,
        steps: buildSteps,
        options: buildOptions);

    AuthClient client = await clientViaMetadataServer();
    var cloudBuildApi = cb.CloudBuildApi(client);
    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    return buildOp;
  }
}
