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

import 'package:cloudprovision/modules/settings/data/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/environment.dart';
import '../../../utils/styles.dart';
import '../../my_services/data/cloud_workstations_repository.dart';
import '../../settings/data/settings_repository.dart';

class CloudWorkstationWidget extends ConsumerStatefulWidget {
  const CloudWorkstationWidget({super.key, required this.onTextFormUpdate});

  final Function onTextFormUpdate;

  @override
  ConsumerState<CloudWorkstationWidget> createState() =>
      _CloudWorkstationState();
}

class _CloudWorkstationState extends ConsumerState<CloudWorkstationWidget> {
  final _keyWS = GlobalKey<FormState>();

  _CloudWorkstationState() {}

  @override
  Widget build(BuildContext parentContext) {
    return _cloudWorkstationSection();
  }

  Widget _cloudWorkstationSection() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Cloud Workstation: ",
              style: AppText.fontStyleBold,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    child: Form(
                      key: _keyWS,
                      child: Column(
                        children: [
                          _workstationCluster(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _workstationCluster() {
    // TODO remove loading settings since we switched to using target project from autocomplete
    var settings = ref.watch(gitSettingsProvider);

    var projectId = ref.read(projectProvider).name;

    if (projectId == "null")
      return Container();

    return settings.when(
        loading: () => Text('Loading...'),
        error: (err, stack) => Text('Error: $err'),
        data: (settings) {
          String region = Environment.getRegion();

          final workstationClustersList = ref.watch(
              WorkstationClustersProvider(projectId: projectId, region: region));

          return workstationClustersList.when(
              loading: () => LinearProgressIndicator(),
              error: (err, stack) => Container(),
              data: (clustersList) {
                if (clustersList.isNotEmpty) {
                  var clusterNames = clustersList
                      .map<String>(
                          (e) => e.name.substring(e.name.lastIndexOf('/') + 1))
                      .toList();

                  var selectClusterText = "Select a cluster";
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text("Cluster"),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 300,
                                child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    return null;
                                  },
                                  hint: Text(selectClusterText),
                                  value: selectClusterText,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (String? value) {
                                    widget.onTextFormUpdate(value!, "_WS_CLUSTER");
                                    ref.read(clusterDropdownProvider.notifier).state =
                                        value;
                                  },
                                  items: [selectClusterText, ...clusterNames]
                                      .map<DropdownMenuItem<String>>(
                                          (String clusterName) {
                                        return DropdownMenuItem<String>(
                                          value: clusterName,
                                          child: Text(clusterName),
                                        );
                                      }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _workstationConfig(projectId, region),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              });

        });
  }

  Widget _workstationConfig(String projectId, String region) {
    String cluster = ref.watch(clusterDropdownProvider);
    Text configNotFound = Text("Configurations not found");

    if (cluster == "Select a cluster")
      return configNotFound;

    final workstationConfigsList = ref.watch(WorkstationConfigsProvider(
        projectId: projectId, region: region, clusterName: cluster));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text("Configuration"),
        ),
        Row(
          children: [
            workstationConfigsList.when(
                loading: () => Container(),
                error: (err, stack) => Container(),
                data: (configsList) {
                  if (configsList.isNotEmpty) {
                    var configNames = configsList
                        .map<String>((config) => config.name
                            .substring(config.name.lastIndexOf('/') + 1))
                        .toList();

                    var selectConfigurationText = "Select a configuration";
                    return SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          return null;
                        },
                        hint: Text(selectConfigurationText),
                        value: selectConfigurationText,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        onChanged: (String? value) {
                          widget.onTextFormUpdate(value!, "_WS_CONFIG");
                        },
                        items: [selectConfigurationText, ...configNames]
                            .map<DropdownMenuItem<String>>((String configName) {
                          return DropdownMenuItem<String>(
                            value: configName,
                            child: Text(configName),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return configNotFound;
                  }
                }),
          ],
        ),
      ],
    );
  }
}
