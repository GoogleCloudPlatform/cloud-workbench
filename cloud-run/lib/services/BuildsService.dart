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
    AuthClient client = await clientViaMetadataServer();
    var cloudBuildApi = cb.CloudBuildApi(client);

    String parent = "projects/${projectId}/locations/global";

    var buildStep = cb.BuildStep.fromJson(cloudProvisionJsonConfig);

    var buildRequest =
        cb.Build(substitutions: substitutionsMap, steps: [buildStep]);

    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    return buildOp;
  }
}
