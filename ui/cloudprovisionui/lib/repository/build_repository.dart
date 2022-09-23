import 'dart:convert';

import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/repository/service/build_service.dart';

class BuildRepository {
  const BuildRepository({required this.service});

  final BuildService service;

  /// Deploys provided template
  ///
  /// [projectId]
  /// [template]
  /// [formFieldValuesMap]
  Future<String> deployTemplate(String projectId, Template template,
          Map<String, dynamic> formFieldValuesMap) async =>
      service.deployTemplate(projectId, template, formFieldValuesMap);

  /// Returns Cloud Build details
  ///
  /// [projectId]
  /// [buildId]
  Future<String> getBuildDetails(String projectId, String buildId) async =>
      service.getBuildDetails(projectId, buildId);

  /// Run Cloud Build Trigger
  ///
  /// [projectId]
  /// [appName]
  Future<String> runTrigger(String projectId, String appName) async =>
      service.runTrigger(projectId, appName);
}
