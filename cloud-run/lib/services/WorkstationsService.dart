import 'dart:convert';
import 'dart:io';

import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:cloud_provision_shared/services/models/cluster.dart';
import 'package:cloud_provision_shared/services/models/workstation.dart';
import 'package:cloud_provision_shared/services/models/workstation_config.dart';
import 'package:http/http.dart';

class WorkstationsService extends BaseService {
  String wsUrl = "workstations.googleapis.com";

  Map<String, String> getRequestHeaders() {
    Map<String, String> requestHeaders = {
      HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      HttpHeaders.authorizationHeader:
          "Bearer ${client.credentials.accessToken.data}"
    };

    return requestHeaders;
  }

  /// Returns list of Cloud Workstations clusters
  ///
  /// [projectId]
  /// [region]
  Future<List<Cluster>> getClusters(String projectId, String region) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters';

    Uri url = Uri.https(wsUrl, endpointPath);

    var client = await getClient();
    Response res = await client.get(url);

    Map<String, dynamic> clusters = jsonDecode(res.body);

    List<Cluster> clustersList = [];

    if (clusters.containsKey('workstationClusters')) {
      for (Map<String, dynamic> cluster in clusters['workstationClusters']) {
        if (!cluster.containsKey("reconciling")) {
          clustersList.add(Cluster.fromJson(cluster));
        }
      }
    }

    return clustersList;
  }

  /// Returns list of Cloud Workstations configurations
  ///
  /// [projectId]
  /// [region]
  Future<List<WorkstationConfig>> getConfigurations(
      String projectId, String clusterName, String region) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs';

    Uri url = Uri.https(wsUrl, endpointPath);

    var client = await getClient();
    Response res = await client.get(url);

    Map<String, dynamic> configs = jsonDecode(res.body);

    List<WorkstationConfig> workstationConfigs = [];

    if (configs.containsKey('workstationConfigs')) {
      for (Map<String, dynamic> config in configs['workstationConfigs']) {
        workstationConfigs.add(WorkstationConfig.fromJson(config));
      }
    }

    return workstationConfigs;
  }

  Future<List<Workstation>> getWorkstations(String projectId,
      String clusterName, String configName, String region) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations';

    Uri url = Uri.https(wsUrl, endpointPath);

    var client = await getClient();
    Response res = await client.get(url);

    Map<String, dynamic> workstationsJson = jsonDecode(res.body);

    List<Workstation> workstations = [];

    if (workstationsJson.containsKey('workstations')) {
      for (Map<String, dynamic> workstation
          in workstationsJson['workstations']) {
        String name = workstation["name"];
        String displayName = name.substring(name.lastIndexOf('/') + 1);

        String host = "";
        if (workstation["host"] != null) {
          host = workstation["host"];
        }

        workstations.add(Workstation(
          name: name,
          displayName: displayName,
          uid: workstation["uid"],
          etag: workstation["etag"],
          state: workstation["state"],
          host: host,
          createTime: DateTime.parse(workstation["createTime"]),
          updateTime: DateTime.parse(workstation["updateTime"]),
          location: region,
          clusterName: clusterName,
          configName: configName,
        ));
      }
    }

    return workstations;
  }

  Future<Response> startWorkstation(String projectId, String clusterName,
      String configName, String workstationName, String region) async {
    return await actionOnWorkstation(
        projectId, region, clusterName, configName, workstationName, "start");
  }

  Future<Response> stopWorkstation(String projectId, String clusterName,
      String configName, String workstationName, String region) async {
    return await actionOnWorkstation(
        projectId, region, clusterName, configName, workstationName, "stop");
  }

  Future<Response> actionOnWorkstation(
      String projectId,
      String region,
      String clusterName,
      String configName,
      String workstationName,
      String action) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}:${action}';

    Uri url = Uri.https(wsUrl, endpointPath);
    var client = await getClient();
    Response res = await client.post(url);

    return res;
  }

  Future<Response> createWorkstation(String projectId, String clusterName, String configName,
      String workstationName, String region) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations';

    Map<String, String> queryParameters = {"workstationId": workstationName};
    Uri url = Uri.https(wsUrl, endpointPath, queryParameters);

    Map<String, String> body = {"name": workstationName};
    var client = await getClient();
    Response res = await client.post(url, body: jsonEncode(body));

    return res;
  }

  Future<Response> deleteWorkstation(String projectId, String clusterName, String configName,
      String workstationName, String region) async {
    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}';

    Uri url = Uri.https(wsUrl, endpointPath);

    var client = await getClient();
    Response res = await client.delete(url);

    return res;
  }

  Future<Response> grantAccessForUser(String projectId, String clusterName, String configName,
      String workstationName, String region, String email) async {

    String endpointPath =
        '/v1beta/projects/${projectId}/locations/${region}/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}:setIamPolicy';

    Uri url = Uri.https(wsUrl, endpointPath);

    Map<String, dynamic> body = {
      "policy": {
        "bindings": [
          {
            "role": "roles/workstations.user",
            "members": ["user:${email}"]
          }
        ]
      }
    };

    var client = await getClient();
    Response res = await client.post(url, body: jsonEncode(body));
    return res;
  }
}
