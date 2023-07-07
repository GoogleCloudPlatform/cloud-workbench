import '../../my_services/models/service.dart';
import '../models/build.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'build_service.dart';

class BuildRepository {
  const BuildRepository({required this.buildService});

  final BuildService buildService;

  /// Deploys provided template
  ///
  /// [projectId]
  /// [template]
  /// [formFieldValuesMap]
  Future<String> deployTemplate(String projectId, Template template,
          Map<String, dynamic> formFieldValuesMap) async =>
      buildService.deployTemplate(projectId, template, formFieldValuesMap);

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
