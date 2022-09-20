import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;

class TriggersService {
  /// Runs Cloud Build trigger
  ///
  /// [projectId]
  /// [branchName]
  /// [triggerName]
  runTrigger(String projectId, String branchName, String triggerName) async {
    AuthClient client = await clientViaMetadataServer();
    var cloudBuildApi = cb.CloudBuildApi(client);

    var list = await cloudBuildApi.projects.triggers.list(projectId);
    late cb.BuildTrigger buildTrigger;
    bool foundTrigger = false;

    list.triggers!.forEach((trigger) {
      if (trigger.name == triggerName) {
        buildTrigger = trigger;
        foundTrigger = true;
      }
    });

    if (foundTrigger) {
      String? triggerId = buildTrigger.id;
      String? triggerName =
          "projects/${projectId}/locations/global/triggers/${buildTrigger.name}";

      cb.RepoSource repoSource = cb.RepoSource(branchName: branchName);
      cb.RunBuildTriggerRequest rbtr = cb.RunBuildTriggerRequest(
          source: repoSource, projectId: projectId, triggerId: triggerId);

      cb.Operation operation = await cloudBuildApi.projects.locations.triggers
          .run(rbtr, triggerName!);

      return operation;
    }

    return null;
  }
}
