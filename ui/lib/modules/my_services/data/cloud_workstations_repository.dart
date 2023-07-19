import 'dart:async';

import 'package:cloudprovision/shared/service/base_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:cloud_provision_shared/services/models/workstation.dart';
import 'package:cloud_provision_shared/services/models/workstation_config.dart';
import 'package:cloud_provision_shared/services/models/cluster.dart';
import 'package:http/http.dart' as http;

part 'cloud_workstations_repository.g.dart';

class CloudWorkstationsRepository extends BaseService {
  /// Returns list of Cloud Workstations Clusters
  /// [projectId]
  /// [region]
  Future<List<Cluster>> getClusters(String projectId, String region) async {
    List<Cluster> clusters = [];

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath = '/v1/workstationClusters';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      clusters = List<Cluster>.from(l.map((model) => Cluster.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return clusters;
  }

  /// Returns list of Cloud Workstations Configurations
  /// [projectId]
  /// [clusterName]
  /// [region]
  Future<List<WorkstationConfig>> getConfigurations(
      String projectId, String clusterName, String region) async {
    List<WorkstationConfig> workstationConfigs = [];

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      workstationConfigs = List<WorkstationConfig>.from(
          l.map((model) => WorkstationConfig.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return workstationConfigs;
  }

  Future<List<Workstation>> getAllWorkstations(
      String projectId, String clusterName, String region) async {
    List<Workstation> workstations = [];

    final configList = await getConfigurations(projectId, clusterName, region);

    List<String> flatConfList = [];

    configList.forEach((config) async {
      final configNameSplit = config.name.split('/');

      flatConfList.add(configNameSplit.last);
    });

    for (int i = 0; i < flatConfList.length; i++) {
      final worklist = await getWorkstations(
        projectId,
        clusterName,
        flatConfList[i],
        region,
      );

      worklist.forEach((station) {
        workstations.add(station);
      });
    }

    return workstations;
  }

  /// Returns list of Cloud Workstations
  /// [projectId]
  /// [clusterName]
  /// [configName]
  /// [region]
  Future<List<Workstation>> getWorkstations(String projectId,
      String clusterName, String configName, String region) async {
    List<Workstation> workstations = [];

    if (projectId == "" ||
        clusterName == "" ||
        configName == "" ||
        region == "") {
      return workstations;
    }

    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);
      workstations =
          List<Workstation>.from(l.map((model) => Workstation.fromJson(model)));
    } catch (e, stack) {
      print(e);
      print(stack);
    }

    return workstations;
  }

  startInstance(String projectId, String clusterName, String configName,
      String workstationName, String region) async {
    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}/start';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .post(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  stopInstance(String projectId, String clusterName, String configName,
      String workstationName, String region) async {
    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}/stop';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .post(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  createInstance(String projectId, String clusterName, String configName,
      String workstationName, String region, String email) async {
    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}';

      final queryParameters = {'projectId': projectId, 'region': region};

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      Map<String, String> body = {"email": email};

      var response = await http
          .post(url, headers: requestHeaders, body: jsonEncode(body))
          .timeout(Duration(seconds: 10));

      return response;
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  deleteInstance(String projectId, String clusterName, String configName,
      String workstationName, String region) async {
    try {
      Map<String, String> requestHeaders = await getRequestHeaders();

      var endpointPath =
          '/v1/workstationClusters/${clusterName}/workstationConfigs/${configName}/workstations/${workstationName}';

      final queryParameters = {
        'projectId': projectId,
        'region': region,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      var response = await http
          .delete(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      return response;
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }
}

final clusterDropdownProvider = StateProvider.autoDispose<String>(
      (ref) => "Select cluster",
);

@riverpod
CloudWorkstationsRepository cloudWorkstationsRepository(
    CloudWorkstationsRepositoryRef ref) {
  return CloudWorkstationsRepository();
}

@riverpod
Future<List<Workstation>> workstations(WorkstationsRef ref,
    {required String projectId,
      required String clusterName,
      required String configName,
      required String region}) {
  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);
  return servicesRepository.getWorkstations(
      projectId, clusterName, configName, region);
}

@riverpod
Future<List<Cluster>> workstationClusters(WorkstationClustersRef ref,
    {required String projectId,
    required String region}) {
  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);
  return servicesRepository.getClusters(projectId, region);
}

@riverpod
Future<List<WorkstationConfig>> workstationConfigs(WorkstationConfigsRef ref,
    {required String projectId,
      required String region,
      required String clusterName}) {
  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);
  return servicesRepository.getConfigurations(projectId, clusterName, region);
}

@riverpod
Future<List<Workstation>> allWorkstations(AllWorkstationsRef ref,
    {required String projectId,
    required String clusterName,
    required String region}) {
  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);
  return servicesRepository.getAllWorkstations(projectId, clusterName, region);
}

@riverpod
Stream<List<Workstation>> checkWorkstationsStatusStream(
    CheckWorkstationsStatusStreamRef ref,
    {required String projectId,
    required String clusterName,
    required String configName,
    required String instanceName,
    required String region}) {

  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);

  final streamController = StreamController<List<Workstation>>();

  Timer.periodic(Duration(seconds: 5), (timer) {
    var workstations = servicesRepository.getWorkstations(
        projectId, clusterName, configName, region);

    workstations.then((wkstList) {
      bool inProgress = false;

      wkstList.forEach((wkstn) {
        print("${wkstn.state} - ${wkstn.displayName}");

        if (wkstn.displayName == instanceName && wkstn.state.contains("STARTING")) {
          print("${wkstn.state}");
          inProgress = true;
          streamController.add(wkstList);
        }
      });


      if (!inProgress) {
        streamController.add(wkstList);
        streamController.close();
        timer.cancel();
        ref.invalidate(workstationsProvider);
      }
    });
  });

  return streamController.stream;
}

@riverpod
Stream<bool> workstationStartingProgress(WorkstationStartingProgressRef ref,
    {required String projectId,
    required String clusterName,
    required String configName,
    required String instanceName,
    required String region}) async* {

  StreamSubscription? subscription;
  final streamController = StreamController<bool>();

  final bool inProgress = true;
  final bool started = false;
  final String startingStatus = "STARTING";

  ref.onDispose(() {
    streamController.close();
    subscription?.cancel();
  });

  final servicesRepository = ref.watch(cloudWorkstationsRepositoryProvider);

  subscription = Stream.periodic(const Duration(seconds: 5), (e) {
    return servicesRepository.getWorkstations(
        projectId, clusterName, configName, region);
  }).listen((futureWorkstationsList) async {

    List<Workstation> ws = await futureWorkstationsList;
    String state = ws.firstWhere((element) => element.displayName == instanceName).state;

    if (state.contains(startingStatus)) {
      if (!streamController.isClosed) {
        streamController.add(inProgress);
      }
    } else {
      if (!streamController.isClosed) {
        streamController.add(started);
      }
      streamController.close();
      subscription?.cancel();
    }
  });

  yield* streamController.stream;
}