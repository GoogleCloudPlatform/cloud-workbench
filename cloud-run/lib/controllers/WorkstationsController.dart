import 'dart:convert';
import 'dart:io';

import 'package:cloud_provision_server/controllers/BaseController.dart';
import 'package:cloud_provision_shared/services/models/cluster.dart';
import 'package:cloud_provision_shared/services/models/workstation_config.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_provision_shared/services/models/workstation.dart';

import '../services/WorkstationsService.dart';

class WorkstationsController extends BaseController {
  WorkstationsService _workstationsService = WorkstationsService();
  
  Router get router {
    final router = Router();
    router.get('/', _getClustersHandler);
    router.get('/<clusterName>/workstationConfigs', _getConfigurationsHandler);
    router.get('/<clusterName>/workstationConfigs/<configName>/workstations', _getWorkstationsHandler);
    router.post('/<clusterName>/workstationConfigs/<configName>/workstations/<workstationName>/start', _startWorkstationHandler);
    router.post('/<clusterName>/workstationConfigs/<configName>/workstations/<workstationName>/stop', _stopWorkstationHandler);
    router.post('/<clusterName>/workstationConfigs/<configName>/workstations/<workstationName>', _createWorkstationHandler);
    router.delete('/<clusterName>/workstationConfigs/<configName>/workstations/<workstationName>', _deleteWorkstationHandler);

    return router;
  }

  Future<Response> _getClustersHandler(Request request) async {
    try {
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;


      List<Cluster> response = await _workstationsService.getClusters(projectId, region);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode(response),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to get workstations"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _getConfigurationsHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;

      List<WorkstationConfig> response = await _workstationsService.getConfigurations(projectId, clusterName, region);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode(response),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to get workstations"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }


  Future<Response> _getWorkstationsHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String configName = request.params['configName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;


      List<Workstation> response = await _workstationsService.getWorkstations(projectId, clusterName, configName, region);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode(response),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to get workstations"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _startWorkstationHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String configName = request.params['configName']!;
      String workstationName = request.params['workstationName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;

      var response = await _workstationsService.startWorkstation(projectId, clusterName, configName, workstationName, region);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode({"msg": "Workstation started"}),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to start workstation"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _stopWorkstationHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String configName = request.params['configName']!;
      String workstationName = request.params['workstationName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;


      var response = await _workstationsService.stopWorkstation(projectId, clusterName, configName, workstationName, region);

      if (response != null) {
        return Response.ok(
          jsonResponseEncode({"msg": "Workstation stop"}),
        );
      } else {
        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to stop workstation"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _createWorkstationHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String configName = request.params['configName']!;
      String workstationName = request.params['workstationName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;

      final body = await request.readAsString();
      Map<String, dynamic> requestMap = jsonDecode(body);

      String email = requestMap["email"];

      http.Response response = await _workstationsService.createWorkstation(projectId, clusterName, configName, workstationName, region);

      if (response.statusCode != HttpStatus.ok) {
        print(response);

        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to create workstation"}),
        );
      }

      response = await _workstationsService.grantAccessForUser(projectId, clusterName, configName, workstationName, region, email);

      if (response.statusCode == HttpStatus.ok) {
        return Response.ok(
          jsonResponseEncode({"msg": "Workstation created"}),
        );
      } else {
        print(response);

        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed to grant workstation access"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }

  Future<Response> _deleteWorkstationHandler(Request request) async {
    try {
      String clusterName = request.params['clusterName']!;
      String configName = request.params['configName']!;
      String workstationName = request.params['workstationName']!;
      String projectId = request.url.queryParameters['projectId']!;
      String region = request.url.queryParameters['region']!;


      http.Response response = await _workstationsService.deleteWorkstation(projectId, clusterName, configName, workstationName, region);

      if (response.statusCode == HttpStatus.ok) {
        return Response.ok(
          jsonResponseEncode({"msg": "Workstation deleted"}),
        );
      } else {
        print(response);

        return Response.internalServerError(
          body: jsonResponseEncode({"msg": "Failed delete workstation"}),
        );
      }
    } on Exception catch (e, stacktrace) {
      print("Exception occurred: $e stackTrace: $stacktrace");
      return Response.internalServerError(
        body: jsonResponseEncode({"msg": "Internal Server Error"}),
      );
    }
  }
}
