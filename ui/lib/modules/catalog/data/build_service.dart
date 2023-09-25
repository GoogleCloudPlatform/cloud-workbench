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

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:cloud_provision_shared/catalog/models/build_details.dart';
import '../../my_services/models/service.dart';
import '../models/build.dart';
import '../../../shared/service/base_service.dart';
import 'package:cloud_provision_shared/services/BuildsService.dart' as sharedBuilds;
import 'package:cloud_provision_shared/services/TriggersService.dart' as sharedTriggers;

class BuildService extends BaseService {

  BuildService(){}

  BuildService.withAccessToken(accessToken) : super.withAccessToken(accessToken);

  /// Deploys selected template
  /// [projectId]
  /// [template]
  /// [templateParameters]
  Future<BuildDetails> deployTemplate(String accessToken, String projectId, Template template,
      Map<String, dynamic> templateParameters) async {
    String result = "";
    BuildDetails? buildDetails;
    try {
      if (serverEnabled) {
        Map<String, String> requestHeaders = await getRequestHeaders();

        var endpointPath = '/v1/builds';

        var url = getUrl(endpointPath);

        var catalogSource = "gcp";

        if (template.sourceUrl.contains("community")) {
          catalogSource = "community";
        }

        var body = json.encode({
          "project_id": projectId,
          "template_id": "${template.id}",
          "cloudProvisionConfigUrl": "${template.cloudProvisionConfigUrl}",
          "params": templateParameters,
          "catalogSource": catalogSource,
          "catalogUrl": "",
          "accessToken": accessToken
        });

        var response = await http
            .post(url, headers: requestHeaders, body: body)
            .timeout(Duration(seconds: 10));

        // if (response.statusCode == 500) {
        //   return null;
        // }

        result = response.body;
      } else {
        sharedBuilds.BuildsService buildsService = new sharedBuilds.BuildsService(accessToken);
        buildDetails = await buildsService.startBuild(projectId, templateParameters,
            template.cloudProvisionConfigUrl, "POST");
      }
    } catch (e) {
      print(e);
    }

    return buildDetails!;
  }

  /// Return Cloud Build details
  /// [projectId]
  /// [buildId]
  Future<String> getBuildDetails(String projectId, String buildId) async {
    String result = "";

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath = '/v1/builds';
      // could be passed as request params
      final queryParameters = {
        'projectId': projectId,
        'buildId': buildId,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;
  }

  /// Runs Cloud Build trigger
  /// [projectId]
  /// [appName]
  Future<String> runTrigger(String projectId, String appName) async {
    String result = "";

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath = '/v1/triggers';

      var url = getUrl(endpointPath);

      var body = json.encode({
        "project_id": projectId,
        "app_name": appName,
      });

      var response = await http
          .post(url, headers: requestHeaders, body: body)
          .timeout(Duration(seconds: 10));

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;
  }

  /// Returns list of Cloud Build records for specified serviceId
  /// [projectId]
  /// [serviceId]
  Future<List<Build>> getTriggerBuilds(
      String projectId, String serviceId) async {
    List<Build> builds = [];

    try {
      if (serverEnabled) {
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
      } else {
        sharedTriggers.TriggersService triggersService = new sharedTriggers.TriggersService(accessToken);
        String triggerName = "${serviceId}-webhook-trigger";
        List<Map<String, String>> triggerBuilds = await triggersService.getTriggerBuilds(projectId, triggerName);
        builds = List<Build>.from(triggerBuilds.map((model) => Build.fromJson(model)));
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return builds;
  }

  Future<String> deleteService(Service service) async {
    String result = "";
    BuildDetails? buildDetails;

    try {
      if (serverEnabled) {
        Map<String, String> requestHeaders = await getRequestHeaders();

        var endpointPath = '/v1/builds';

        var url = getUrl(endpointPath);
        service.params.remove("tags");
        var body = json.encode({
          "project_id": service.projectId,
          "cloudProvisionConfigUrl": "${service.template!
              .cloudProvisionConfigUrl}",
          "params": service.params,
        });


        var response = await http
            .delete(url, headers: requestHeaders, body: body)
            .timeout(Duration(seconds: 10));

        if (response.statusCode == 500) {
          return result;
        }

        result = response.body;
      } else {
        sharedBuilds.BuildsService buildsService = new sharedBuilds.BuildsService(accessToken);

        Map<String, String>? params =
        service.params.map((key, value) => MapEntry(key, value.toString()));

        params.remove("tags");

        buildDetails = await buildsService.startBuild(service.projectId, params,
            service.template!.cloudProvisionConfigUrl, "DELETE");
        return buildDetails.toString();
      }
    } catch (e) {
      print(e);
    }

    return result;

  }
}
