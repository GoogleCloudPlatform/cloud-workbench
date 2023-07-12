import 'package:cloudprovision/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/styles.dart';
import '../../../widgets/summary_item.dart';

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'dart:convert';

import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:cloudprovision/modules/my_services/data/services_repository.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../my_services/data/cloud_workstations_repository.dart';
import '../data/build_repository.dart';
import 'package:cloud_provision_shared/catalog/models/param.dart';
import '../../my_services/models/service.dart';
import '../data/build_service.dart';

import '../data/template_repository.dart';
import 'git_owners_dropdown.dart';

class CatalogEntryDeployDialog extends ConsumerStatefulWidget {
  final String catalogSource;
  final Template _template;

  CatalogEntryDeployDialog(this._template, this.catalogSource, {super.key});

  @override
  ConsumerState<CatalogEntryDeployDialog> createState() =>
      _MyTemplateDialogState(_template);
}

class _MyTemplateDialogState extends ConsumerState<CatalogEntryDeployDialog> {
  final Template _template;
  String _appId = "";

  Map<String, dynamic> _formFieldValues = {};
  final _key = GlobalKey<FormState>();
  final _keyWS = GlobalKey<FormState>();

  _MyTemplateDialogState(this._template);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(100),
          padding: EdgeInsets.all(25),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              _templateDetails(_template, context),
            ],
          ),
        ),
      ),
    );
  }

  Row _deployButton(Template template) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: "state.instanceGitToken" != ""
                      ? ElevatedButton(
                    child: Text(
                      'Deploy template',
                      style: AppText.buttonFontStyle,
                    ),
                    onPressed: () => _deployTemplate(template),
                  )
                      : Text(
                    "Please configure APIs integrations in the Settings section.",
                    style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
  }

  _templateDetails(Template template, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Template Details Section
                  SummaryItem(label: "Template", child: Text(template.name)),
                  SummaryItem(
                      label: "Description", child: Text(template.description)),
                  SummaryItem(label: "Owner", child: Text(template.owner)),
                  SummaryItem(label: "Version", child: Text(template.version)),
                  SummaryItem(
                      label: "Last modified",
                      child: Text(DateFormat('MM/d/yy, h:mm a')
                              .format(template.lastModified) +
                          "  (${timeago.format(template.lastModified)})")),
                  SummaryItem(label: "Tags", child: Text('${template.tags}')),
                  SummaryItem(
                      label: "Category", child: Text('${template.category}')),
                  Divider(),
                  // Resources Section
                  SummaryItem(
                    label: "Template Repo",
                    child: TextButton(
                      onPressed: () async {
                        final Uri _url = Uri.parse(template.sourceUrl);
                        if (!await launchUrl(_url)) {
                          throw 'Could not launch $_url';
                        }
                      },
                      child: Text("GitHub repo"),
                    ),
                  ),
                  SummaryItem(
                    label: "CloudBuild config",
                    child: TextButton(
                      onPressed: () async {
                        final Uri _url =
                            Uri.parse(template.cloudProvisionConfigUrl);
                        if (!await launchUrl(_url)) {
                          throw 'Could not launch $_url';
                        }
                      },
                      child: Text(
                        "GitHub repo",
                        style: AppText.linkFontStyle,
                      ),
                    ),
                  ),
                  Divider(),
                  // Template Inputs  Section
                  Text(
                    "Template Parameters: ",
                    style: AppText.fontStyleBold,
                  ),
                  _dynamicParamsSection(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dynamicParamsSection() {
    final asyncTemplateValue =
        ref.watch(templateByIdProvider(_template.id, _template.category));

    return asyncTemplateValue.when(
      data: (template) {
        return Column(
          children: [
            Container(
              child: _dynamicParamsForm(template),
            ),
            Divider(),
            _cloudWorkstationSection(),
            _deployButton(template),
          ],
        );
      },
      loading: () => _buildLoading(),
      error: (err, st) => Center(
        child: Text(
          err.toString(),
        ),
      ),
    );
  }

  _dynamicParamsForm(Template template) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _key,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: template.inputs.length,
                itemBuilder: (context, index) {
                  return _buildDynamicParam(index, template.inputs[index]);
                },
              ),
            ],
          ),
        ),

      ],
    );
  }

  _deployTemplate(Template template) async {
    if (!_key.currentState!.validate()) {
      return;
    }

    String projectId = Environment.getProjectId();

    bool isCICDenabled = false;
    template.inputs.forEach((element) {
      if (element.param == "_INSTANCE_GIT_REPO_OWNER") {
        isCICDenabled = true;
      }
    });

    GitSettings gitSettings =
        await ref.read(settingsRepositoryProvider).loadGitSettings();

    if (isCICDenabled) {
      _formFieldValues["_INSTANCE_GIT_REPO_OWNER"] =
          gitSettings.instanceGitUsername;
      _formFieldValues["_INSTANCE_GIT_REPO_TOKEN"] =
          gitSettings.instanceGitToken;
      _formFieldValues["_API_KEY"] = gitSettings.gcpApiKey;
    }
    _formFieldValues["_APP_ID"] = _appId;

    try {
      String buildDetails = await BuildRepository(buildService: BuildService())
          .deployTemplate(projectId, template, _formFieldValues);

      if (buildDetails != "") {
        Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

        _formFieldValues["tags"] = template.tags;

        final user = FirebaseAuth.instance.currentUser!;

        Service deployedService = Service(
            user: user.displayName!,
            userEmail: user.email!,
            serviceId: _appId,
            name: _formFieldValues["_APP_NAME"],
            owner: gitSettings.instanceGitUsername,
            instanceRepo:
                "https://github.com/${_formFieldValues["_INSTANCE_GIT_REPO_OWNER"]}/${_appId}",
            templateName: template.name,
            templateId: template.id,
            template: template,
            region: _formFieldValues["_REGION"],
            projectId: projectId,
            cloudBuildId: buildConfig['build']['id'],
            cloudBuildLogUrl: buildConfig['build']['logUrl'],
            params: _formFieldValues,
            deploymentDate: DateTime.now(),
            workstationCluster: _formFieldValues.containsKey("_WS_CLUSTER") && _formFieldValues["_WS_CLUSTER"] != "Select cluster"
                ? _formFieldValues["_WS_CLUSTER"]
                : "",
            workstationConfig: _formFieldValues.containsKey("_WS_CONFIG")
                && _formFieldValues["_WS_CLUSTER"] != "Select cluster"
                && _formFieldValues["_WS_CONFIG"] != "Select configuration"
                ? _formFieldValues["_WS_CONFIG"]
                : "");

        await ref.read(servicesRepositoryProvider).addService(deployedService);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Deployment started"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );

        context.go("/services");
      } else {

      }
    } on Error catch (e, stacktrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deployment failed"),
          backgroundColor: Colors.red,
        ),
      );

      print("Error occurred: $e stackTrace: $stacktrace");
      Navigator.of(context).pop();
    }
  }

  _buildDynamicParam(int index, Param param) {
    if (param.display == false) {
      return Container();
    }

    if (param.param == "_REGION") {
      _formFieldValues["_REGION"] = dotenv.get("DEFAULT_REGION");
    }

    Widget appId = Container();
    if (param.param == "_APP_NAME") {
      appId = Container(
        // color: Colors.lightBlueAccent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text("App ID: ${_appId}"),
            )
          ],
        ),
      );
    }

    if (param.param == "_INSTANCE_GIT_REPO_OWNER") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text("Git Repository:"),
          ),
          Row(
            children: [
              SizedBox(
                width: 40,
              ),
              GitOwnersDropdown(onTextFormUpdate: _onTextFormUpdate),
              Text(" / "),
              Text("${_appId}"),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }

    return Container(
      child: TextFormField(
          maxLength: 30,
          initialValue:
              (param.param == "_REGION") ? dotenv.get("DEFAULT_REGION") : "",
          decoration: InputDecoration(
            icon: Icon(Icons.abc_sharp),
            labelText: param.label,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          onChanged: (val) {
            String tmpValue = val;

            if (param.param == "_APP_NAME") {
              tmpValue = _cleanName(tmpValue);

              final validCharacters = RegExp(r'^[a-z0-9\-]+$');

              if (tmpValue == "" || validCharacters.hasMatch(tmpValue)) {
                setState(() {
                  _appId = tmpValue;
                });
              }
            }

            _onTextFormUpdate(val, param.param);
          }),
    );
  }

  String _cleanName(String tmpValue) {
    return tmpValue
        .replaceAll(" ", "")
        .replaceAll("!", "")
        .replaceAll("@", "")
        .replaceAll("#", "")
        .replaceAll("\$", "")
        .replaceAll("%", "")
        .replaceAll("^", "")
        .replaceAll("&", "")
        .replaceAll("*", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("_", "")
        .replaceAll("_", "")
        .replaceAll(".", "")
        .replaceAll(",", "")
        .replaceAll(";", "")
        .replaceAll(":", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("\\", "")
        .replaceAll("//", "")
        .replaceAll("~", "")
        .replaceAll(">", "")
        .replaceAll("<", "")
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("|", "")
        .replaceAll("=", "")
        .replaceAll("+", "")
        .replaceAll("+", "")
        .replaceAll("`", "")
        .replaceAll("\"", "")
        // .replaceAll(
        //     RegExp(r'\!\@\#\$\%\^\&\*\(\)'),
        //     "-")
        .toLowerCase();
  }

  _onTextFormUpdate(String val, String param) async {
    String key = param;
    if (_formFieldValues.containsKey(key)) {
      _formFieldValues.remove(key);
    }

    _formFieldValues[key] = val;
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        child: CircularProgressIndicator(),
        height: 10.0,
        width: 10.0,
      ),
    );
  }

  _cloudWorkstationSection() {
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
                          _workstationFields(),
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

  _workstationConfig(String projectId, String region, String clusterName) {

    String clusterName = ref.watch(clusterDropdownProvider);

    final workstationConfigsList = ref.watch(WorkstationConfigsProvider(
        projectId: projectId, region: region, clusterName: clusterName));

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
                    if (configsList.length == 1) {
                      String configName = configsList.first.name;

                      String name =
                      configName.substring(configName.lastIndexOf('/') + 1);

                      return TextFormField(
                        maxLength: 30,
                        decoration: InputDecoration(
                          icon: Icon(Icons.abc_sharp),
                          labelText: "Workstations Config Name",
                        ),
                        initialValue: name,
                        readOnly: true,
                        validator: (value) {
                          return null;
                        },
                        onChanged: (val) {
                          _onTextFormUpdate(val, "_WS_CONFIG");
                        },
                      );
                    } else {
                      var configNames = configsList
                          .map<String>((config) =>
                          config.name.substring(config.name.lastIndexOf('/') + 1))
                          .toList();

                      var selectConfigurationText = "Select configuration";
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
                            _onTextFormUpdate(value!, "_WS_CONFIG");
                          },
                          items: [
                            selectConfigurationText,
                            ...configNames
                          ].map<DropdownMenuItem<String>>((String configName) {
                            return DropdownMenuItem<String>(
                              value: configName,
                              child: Text(configName),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  } else {
                    return Text("No configurations available");
                  }
                }),
          ],
        ),
      ],
    );
  }

  Widget _workstationFields() {
    String projectId = Environment.getProjectId();
    String region = Environment.getRegion();

    final workstationClustersList = ref.watch(
        WorkstationClustersProvider(projectId: projectId, region: region));

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
            workstationClustersList.when(
                loading: () => Container(),
                error: (err, stack) => Container(),
                data: (clustersList) {
                  if (clustersList.isNotEmpty) {
                    if (clustersList.length == 1) {
                      String clusterName = clustersList.first.name
                          .substring(clustersList.first.name.lastIndexOf('/') + 1);

                      _onTextFormUpdate(clusterName, "_WS_CLUSTER");
                      return Column(
                        children: [
                          TextFormField(
                            maxLength: 30,
                            decoration: InputDecoration(
                              icon: Icon(Icons.abc_sharp),
                              labelText: "Cluster",
                            ),
                            initialValue: clusterName,
                            readOnly: true,
                            validator: (value) {
                              return null;
                            },
                            onChanged: (val) {
                              _onTextFormUpdate(val, "_WS_CLUSTER");
                            },
                          ),
                          _workstationConfig(projectId, region, clusterName),
                        ],
                      );
                    } else {
                      var clusterNames = clustersList
                          .map<String>((e) =>
                          e.name.substring(e.name.lastIndexOf('/') + 1))
                          .toList();

                      var selectClusterText = "Select cluster";
                      return Column(
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
                                _onTextFormUpdate(value!, "_WS_CLUSTER");
                                ref.read(clusterDropdownProvider.notifier).state = value;
                              },
                              items: [
                                selectClusterText,
                                ...clusterNames
                              ].map<DropdownMenuItem<String>>((String clusterName) {
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
                          _workstationConfig(projectId, region, selectClusterText),
                        ],
                      );
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ],
    );
  }

}
