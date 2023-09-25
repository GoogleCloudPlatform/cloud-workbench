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

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_provider.dart';
import '../models/recommendation_insight.dart';
import '../models/vulnerability.dart';
import 'security_service.dart';

part 'security_repository.g.dart';

class SecurityRepository {
  const SecurityRepository({required this.service});

  final SecurityService service;

  /// Returns list of vulnerabilities
  /// [projectId]
  /// [serviceId]
  Future<List<Vulnerability>> getContainerVulnerabilities(
          String projectId, String serviceId) async =>
      service.getContainerVulnerabilities(projectId, serviceId);

  // Returns Security Recommendations
  /// [projectId]
  /// [serviceId]
  Future<List<RecommendationInsight>> getSecurityRecommendations(
          String projectId, String region, String serviceId) async =>
      service.getSecurityRecommendations(projectId, region, serviceId);
}

@riverpod
SecurityRepository securityRepository(
    SecurityRepositoryRef ref) {

  final authRepo = ref.watch(authRepositoryProvider);
  var authClient = authRepo.getAuthClient();
  String accessToken = authClient.credentials.accessToken.data;

  return SecurityRepository(service: SecurityService.withAccessToken(accessToken));
}

@riverpod
Future<List<Vulnerability>> containerVulnerabilities(ContainerVulnerabilitiesRef ref,
    {required String projectId, required String serviceId}) {
  final securityRepository = ref.watch(securityRepositoryProvider);
  return securityRepository.getContainerVulnerabilities(projectId, serviceId);
}

@riverpod
Future<List<RecommendationInsight>> securityRecommendations(SecurityRecommendationsRef ref,
    {required String projectId, required String region, required String serviceId}) {
  final securityRepository = ref.watch(securityRepositoryProvider);
  return securityRepository.getSecurityRecommendations(projectId, region, serviceId);
}