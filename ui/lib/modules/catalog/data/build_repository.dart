import 'package:cloud_provision_shared/catalog/models/build_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_provider.dart';
import '../../my_services/models/service.dart';
import '../models/build.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'build_service.dart';

part 'build_repository.g.dart';

class BuildRepository {
  const BuildRepository({required this.buildService});

  final BuildService buildService;

  /// Deploys provided template
  ///
  /// [projectId]
  /// [template]
  /// [templateParameters]
  Future<BuildDetails> deployTemplate(String accessToken, String projectId, Template template,
          Map<String, String> templateParameters) async =>
      buildService.deployTemplate(accessToken, projectId, template, templateParameters);

  /// Returns Cloud Build details
  ///
  /// [projectId]
  /// [buildId]
  Future<String> getBuildDetails(String projectId, String buildId) async =>
      buildService.getBuildDetails(projectId, buildId);

  /// Run Cloud Build Trigger
  ///
  /// [projectId]
  /// [appName]
  Future<String> runTrigger(String projectId, String appName) async =>
      buildService.runTrigger(projectId, appName);

  /// Returns list of Cloud Build records for specified serviceId
  /// [projectId]
  /// [serviceId]
  Future<List<Build>> getTriggerBuilds(
          String projectId, String serviceId) async =>
      buildService.getTriggerBuilds(projectId, serviceId);

  Future<String> deleteService(Service service)  async =>
      buildService.deleteService(service);
}

@riverpod
BuildRepository buildRepository(
    BuildRepositoryRef ref) {

  final authRepo = ref.watch(authRepositoryProvider);
  var authClient = authRepo.getAuthClient();
  String accessToken = authClient.credentials.accessToken.data;

  return BuildRepository(buildService: BuildService.withAccessToken(accessToken));
}

@riverpod
Future<List<Build>> triggerBuilds(TriggerBuildsRef ref,
    {required String projectId, required String serviceId}) {
  final buildsRepository = ref.watch(buildRepositoryProvider);
  return buildsRepository.getTriggerBuilds(projectId, serviceId);
}
