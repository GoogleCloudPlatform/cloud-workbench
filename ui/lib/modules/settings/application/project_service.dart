import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:cloudprovision/modules/settings/data/project_provider.dart';
import 'package:cloudprovision/modules/settings/data/project_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_service.g.dart';

class ProjectService {
  ProjectService(this.ref);

  final Ref ref;

  Future<bool> bootstrapTargetProject(Project project) async {
    try {

      if (project.name != "null") {
        final ProjectRepository projectRepository = ref.read(
            projectRepositoryProvider);
        projectRepository.enableAPIs(project.projectId);

        // This could be moved to template scripts to setup the dependencies
        projectRepository.createArtifactRegistry(
            project.projectId, "us-central1", "cp-repo", "DOCKER");

        projectRepository.grantRoles(project.projectId, project.projectNumber);
      }
    } on Error catch (e, stacktrace) {
      print("Error occurred: $e stackTrace: $stacktrace");
      return false;
      }

      return true;
  }

}

@riverpod
ProjectService projectService(ProjectServiceRef ref) {
  return ProjectService(ref);
}