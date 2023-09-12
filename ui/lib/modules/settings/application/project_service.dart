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
        final ProjectRepository projectRepository =
            ref.read(projectRepositoryProvider);
        projectRepository.enableServices(project.projectId);

        // TODO This could be moved to template scripts to setup the dependencies
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

  Future<bool> isServiceEnabled(Project project, String serviceName) async {
    final ProjectRepository projectRepository =
        ref.read(projectRepositoryProvider);

    return await projectRepository.verifyService(
        project.projectId, serviceName);
  }
}

@riverpod
ProjectService projectService(ProjectServiceRef ref) {
  return ProjectService(ref);
}

@riverpod
Future<bool> serviceStatus(ServiceStatusRef ref,
    {required Project project, required String serviceName}) {
  ProjectService projectService = ref.read(projectServiceProvider);
  return projectService.isServiceEnabled(project, serviceName);
}
