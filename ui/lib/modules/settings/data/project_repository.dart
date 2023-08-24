import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloudprovision/shared/service/base_service.dart';

class ProjectRepository extends BaseService {

  ProjectRepository(String accessToken) :
        super.withAccessToken(accessToken);

  enableAPIs(String projectId) async {
    ProjectService projectService = new ProjectService(accessToken);

    var apis = [
      "cloudbuild.googleapis.com",
      "workstations.googleapis.com",
      "secretmanager.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "artifactregistry.googleapis.com",
      "run.googleapis.com",
      "container.googleapis.com",
      "containeranalysis.googleapis.com",
      "recommender.googleapis.com",
      "containerscanning.googleapis.com",
    ];

    apis.forEach((serviceName) async {
      await projectService.enableAPIs(projectId, serviceName);
    });
  }

  createArtifactRegistry(String projectId, String region, String name,
      String format) async {
    ProjectService projectService = new ProjectService(accessToken);
    await projectService.createArtifactRegistry(projectId, region, name, format);
  }

  grantRoles(String projectId, String projectNumber) async {
    ProjectService projectService = new ProjectService(accessToken);
    await projectService.grantRoles(projectId, projectNumber);
  }
}