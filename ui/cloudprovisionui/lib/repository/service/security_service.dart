import 'package:cloudprovision/repository/models/build.dart';
import 'package:cloudprovision/repository/models/recommendation_insight.dart';
import 'package:cloudprovision/repository/models/vulnerability.dart';
import 'package:cloudprovision/repository/service/base_service.dart';
import 'dart:convert';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class SecurityService extends BaseService {
  /// Returns list of Cloud Build records for specified serviceId
  /// [projectId]
  /// [serviceId]
  Future<List<Build>> getTriggerBuilds(
      String projectId, String serviceId) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    List<Build> builds = [];

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/triggers/${serviceId}/builds';

      final queryParameters = {
        'projectId': projectId,
      };

      var url =
          Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);
      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
      }

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
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    List<Vulnerability> vulnerabilities = [];

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/security/${serviceId}/vulnerabilities';

      final queryParameters = {
        'projectId': projectId,
      };

      var url =
          Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);
      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
      }

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      vulnerabilities = List<Vulnerability>.from(
          l.map((model) => Vulnerability.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return vulnerabilities;
  }

  Future<List<RecommendationInsight>> getSecurityRecommendations(
      String projectId, String serviceId) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();
    List<RecommendationInsight> recommendations = [];

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
        HttpHeaders.contentTypeHeader: "application/json"
      };

      var endpointPath = '/v1/security/${serviceId}/recommendations';

      final queryParameters = {
        'projectId': projectId,
      };

      var url =
          Uri.https(cloudProvisionServerUrl, endpointPath, queryParameters);
      if (cloudProvisionServerUrl.contains("localhost")) {
        url = Uri.http(cloudProvisionServerUrl, endpointPath, queryParameters);
      }

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      recommendations = List<RecommendationInsight>.from(
          l.map((model) => RecommendationInsight.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return recommendations;
  }
}
