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

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../catalog/models/build.dart';
import '../models/recommendation_insight.dart';
import '../models/vulnerability.dart';
import '../../../shared/service/base_service.dart';

import 'package:cloud_provision_shared/services/SecurityService.dart' as sharedService;


class SecurityService extends BaseService {

  SecurityService(){}

  SecurityService.withAccessToken(accessToken) : super.withAccessToken(accessToken);

  /// Returns list of Cloud Build records for specified serviceId
  /// [projectId]
  /// [serviceId]
  Future<List<Build>> getTriggerBuilds(
      String projectId, String serviceId) async {
    List<Build> builds = [];

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath = '/v1/triggers/${serviceId}/builds';

      final queryParameters = {
        'projectId': projectId,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      builds = List<Build>.from(l.map((model) => Build.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return builds;
  }

  Future<List<Vulnerability>> getContainerVulnerabilities(
      String projectId, String serviceId) async {
    List<Vulnerability> vulnerabilities = [];

    try {
      if (serverEnabled) {
        Map<String, String> requestHeaders = await getRequestHeaders();

        var endpointPath = '/v1/security/${serviceId}/vulnerabilities';

        final queryParameters = {
          'projectId': projectId,
        };

        var url = getUrl(endpointPath, queryParameters: queryParameters);

        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(Duration(seconds: 10));

        Iterable l = json.decode(response.body);
        vulnerabilities = List<Vulnerability>.from(
            l.map((model) => Vulnerability.fromJson(model)));
      } else {
        sharedService.SecurityService securityService = new sharedService.SecurityService(accessToken);
        List<Map<String, String>> vulnResponse = await securityService.getContainerVulnerabilities(projectId, serviceId);
        vulnerabilities = List<Vulnerability>.from(
            vulnResponse.map((model) => Vulnerability.fromJson(model)));
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return vulnerabilities;
  }

  Future<List<RecommendationInsight>> getSecurityRecommendations(
      String projectId, String region, String serviceId) async {
    List<RecommendationInsight> recommendations = [];

    try {
      if (serverEnabled) {
        Map<String, String> requestHeaders = await getRequestHeaders();

        var endpointPath = '/v1/security/${serviceId}/recommendations';

        final queryParameters = {
          'projectId': projectId,
        };

        var url = getUrl(endpointPath, queryParameters: queryParameters);

        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(Duration(seconds: 10));

        Iterable l = json.decode(response.body);
        recommendations = List<RecommendationInsight>.from(
            l.map((model) => RecommendationInsight.fromJson(model)));
      } else {
        sharedService.SecurityService securityService = new sharedService.SecurityService(accessToken);
        List<Map<String, String>> secResponse = await securityService.getSecurityRecommendations(projectId, region, serviceId);
        recommendations = List<RecommendationInsight>.from(
            secResponse.map((model) => RecommendationInsight.fromJson(model)));
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return recommendations;
  }
}
