// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
