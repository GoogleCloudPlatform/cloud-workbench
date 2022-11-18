import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;

class TriggersService extends BaseService {
  /// Runs Cloud Build trigger
  ///
  /// [projectId]
  /// [branchName]
  /// [triggerName]
  runTrigger(String projectId, String branchName, String triggerName) async {
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

  getTriggerBuilds(String? projectId, String triggerName) async {
    var cloudBuildApi = cb.CloudBuildApi(client);
    var list = await cloudBuildApi.projects.triggers.list(projectId!);
    late cb.BuildTrigger buildTrigger;
    bool foundTrigger = false;

    list.triggers!.forEach((trigger) {
      if (trigger.name == triggerName) {
        buildTrigger = trigger;
        foundTrigger = true;
      }
    });
    List<Map<String, String>> response = [];
    if (foundTrigger) {
      String? triggerId = buildTrigger.id;

      String parent = "projects/${projectId}/locations/global";

      cb.ListBuildsResponse buildsList = await cloudBuildApi.projects.builds
          .list(projectId!, parent: parent, filter: "trigger_id=${triggerId}");

      List<cb.Build>? builds = buildsList.builds;

      for (cb.Build build in builds!) {
        response.add(Map.from({
          'buildId': build.id,
          'status': build.status,
          'createTime': build.createTime,
          'finishTime': build.finishTime,
          'buildTriggerId': build.buildTriggerId,
          'projectId': build.projectId,
          'buildLogUrl': build.logUrl,
        }));
      }
    }

    return response;
  }
}
