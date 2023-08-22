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
  /// [formFieldValuesMap]
  Future<BuildDetails> deployTemplate(String accessToken, String projectId, Template template,
      Map<String, dynamic> formFieldValuesMap) async {
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
          "params": formFieldValuesMap,
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
        buildDetails = await buildsService.startBuild(projectId, formFieldValuesMap,
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

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath = '/v1/builds';

      var url = getUrl(endpointPath);
      service.params.remove("tags");
      var body = json.encode({
        "project_id": service.projectId,
        "cloudProvisionConfigUrl": "${service.template!.cloudProvisionConfigUrl}",
        "params": service.params,
      });


      var response = await http
          .delete(url, headers: requestHeaders, body: body)
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 500) {
        return result;
      }

      result = response.body;
    } catch (e) {
      print(e);
    }

    return result;

  }
}
