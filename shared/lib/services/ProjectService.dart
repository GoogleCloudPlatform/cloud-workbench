import 'dart:io';

import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:googleapis/cloudresourcemanager/v1.dart' as crm;
import 'package:googleapis/serviceusage/v1.dart' as su;
import 'package:googleapis/artifactregistry/v1.dart' as ar;

import 'BaseService.dart';


class ProjectService extends BaseService {

  ProjectService(String accessToken) : super(accessToken);

  String wsUrl = "cloudresourcemanager.googleapis.com";

  Future<List<Project>> getProjects() async {
    List<Project> projectsList = [];

    crm.CloudResourceManagerApi cloudResourceManagerApi = new crm.CloudResourceManagerApi(getAuthenticatedClient());
    crm.ListProjectsResponse list = await cloudResourceManagerApi.projects.list(filter: 'lifecycleState:ACTIVE');
    list.projects!.forEach((project) {
      projectsList.add(Project.fromJson(project.toJson()));
    });

    // String endpointPath = '/v1/projects';
    // final queryParameters = {
    //   'filter': 'lifecycleState:ACTIVE',
    // };
    // Uri url = Uri.https(wsUrl, endpointPath, queryParameters);

    // Option 1 - http client
    // Response res = await http.get(url, headers: getRequestHeaders());
    // Option 2 - AuthClient
    // Response res = await authClient.get(url);

    // Map<String, dynamic> projects = jsonDecode(res.body);
    //   for (Map<String, dynamic> project in projects['projects']) {
    //     projectsList.add(Project.fromJson(project));
    //   }

    return projectsList;
  }

  enableService(String projectId, String serviceName) async {
    if (projectId == "null")
      return;

    String service = 'projects/${projectId}/services/${serviceName}';
    su.ServiceUsageApi serviceUsageApi = new su.ServiceUsageApi(getAuthenticatedClient());
    su.GoogleApiServiceusageV1Service res = await serviceUsageApi.services.get(service);

    if (res.state == "DISABLED") {
      su.EnableServiceRequest request = new su.EnableServiceRequest();
      su.Operation enableRequest = await serviceUsageApi.services.enable(request, service);
    }/* else {
      su.DisableServiceRequest request = new su.DisableServiceRequest();
      su.Operation disableRequest = await serviceUsageApi.services.disable(request, service);
    }*/
  }

  isServiceEnabled(String projectId, String serviceName) async {
    if (projectId == "null")
      return;

    String service = 'projects/${projectId}/services/${serviceName}';
    su.ServiceUsageApi serviceUsageApi = new su.ServiceUsageApi(getAuthenticatedClient());
    su.GoogleApiServiceusageV1Service res = await serviceUsageApi.services.get(service);

    return res.state == "ENABLED";
  }

  grantRoles(String projectId, String projectNumber) async {

    if (projectId == "null")
      return;

    crm.CloudResourceManagerApi cloudResourceManagerApi = new crm.CloudResourceManagerApi(getAuthenticatedClient());
    crm.GetIamPolicyRequest request = new crm.GetIamPolicyRequest();
    crm.Policy projectPolicy = await cloudResourceManagerApi.projects.getIamPolicy(request, projectId);

    String saCloudBuild = "serviceAccount:${projectNumber}@cloudbuild.gserviceaccount.com";

    projectPolicy.bindings?.add(createNewBinding(saCloudBuild, "roles/run.admin"));
    projectPolicy.bindings?.add(createNewBinding(saCloudBuild, "roles/secretmanager.admin"));
    projectPolicy.bindings?.add(createNewBinding(saCloudBuild, "roles/iam.serviceAccountUser"));

    projectPolicy.bindings?.add(createNewBinding("serviceAccount:${projectNumber}-compute@developer.gserviceaccount.com", "roles/editor"));
    projectPolicy.bindings?.add(createNewBinding("serviceAccount:service-${projectNumber}@gcp-sa-cloudbuild.iam.gserviceaccount.com", "roles/secretmanager.admin"));

    // Granting access to Cloud Build service account from Cloud Workbench project
    // String saCloudBuildCW = "serviceAccount:NNNNNNNNNNN@cloudbuild.gserviceaccount.com";
    //
    // projectPolicy.bindings?.add(createNewBinding(saCloudBuildCW, "roles/run.developer"));
    // projectPolicy.bindings?.add(createNewBinding(saCloudBuildCW, "roles/secretmanager.admin"));
    // projectPolicy.bindings?.add(createNewBinding(saCloudBuildCW, "roles/iam.serviceAccountUser"));

    crm.SetIamPolicyRequest setRequest = new crm.SetIamPolicyRequest();
    setRequest.policy = projectPolicy;
    crm.Policy updatedProjectPolicy = await cloudResourceManagerApi.projects.setIamPolicy(setRequest, projectId);

  }

  createNewBinding(String member, String role) {
    crm.Binding newBinding = new crm.Binding();
    newBinding.members = [member];
    newBinding.role = role;
    return newBinding;
  }

  createArtifactRegistry(String projectId, String region, String name,
      String format) async {
    String parent = 'projects/${projectId}/locations/${region}';

    ar.ArtifactRegistryApi artifactRegistryApi = new ar.ArtifactRegistryApi(getAuthenticatedClient());

    ar.Repository request = new ar.Repository();
    request.name = name;
    request.format = format;

    ar.Operation operation = await artifactRegistryApi.projects.locations.repositories.create(request, parent, repositoryId: name);
  }
}