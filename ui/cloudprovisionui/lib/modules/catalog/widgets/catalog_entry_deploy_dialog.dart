import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/styles.dart';

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'dart:convert';

import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:cloudprovision/modules/my_services/data/services_repository.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../firebase_options.dart';
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
  String _appName = "";
  String _appId = "";

  Map<String, dynamic> _cloudBuildDetails = {};
  bool _building = false;
  bool _buildDone = false;
  String _cloudBuildStatus = "";

  Map<String, dynamic> _cloudBuildTriggerDetails = {};
  bool _buildingTrigger = false;
  bool _buildTriggerDone = false;
  String _cloudBuildTriggerStatus = "";

  Map<String, dynamic> _formFieldValues = {};
  final _key = GlobalKey<FormState>();

  String _errorMessage = "";

  _MyTemplateDialogState(this._template);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(100),
        padding: EdgeInsets.all(25),
        color: Colors.white,
        child: Column(
          children: [
            _templateDetails(_template, context),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Close',
                style: AppText.linkFontStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  _templateDetails(Template template, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          'Template:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(template.name)
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Description:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${template.description}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Owner:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${template.owner}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Version:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${template.version}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Last modified:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        DateFormat('MM/d/yy, h:mm a')
                            .format(template.lastModified),
                        style: AppText.fontStyle,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(${timeago.format(template.lastModified)})",
                        style: AppText.fontStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Tags:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${template.tags}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "Template Repo: ",
                        style: AppText.fontStyleBold,
                      ),
                      TextButton(
                        onPressed: () async {
                          final Uri _url = Uri.parse(template.sourceUrl);
                          if (!await launchUrl(_url)) {
                            throw 'Could not launch $_url';
                          }
                        },
                        child: Text(
                          "GitHub repo",
                          style: AppText.linkFontStyle,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "CloudBuild config: ",
                        style: AppText.fontStyleBold,
                      ),
                      TextButton(
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "Template Parameters: ",
                        style: AppText.fontStyleBold,
                      ),
                    ],
                  ),
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      _dynamicParamsSection(),
                    ],
                  ),
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
        return Container(
          child: _dynamicParams(template),
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

  _dynamicParams(Template template) {
    return Container(
      // color: Colors.cyan,
      // width: MediaQuery.of(context).size.width * 0.90,
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            child: Form(
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
                  TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                      icon: Icon(Icons.abc_sharp),
                      labelText: "Workstations Cluster Name",
                    ),
                    validator: (value) {
                      return null;
                    },
                    onChanged: (val) {
                      _onTextFormUpdate(val, "_WS_CLUSTER");
                    },
                  ),
                  TextFormField(
                    maxLength: 30,
                    decoration: InputDecoration(
                      icon: Icon(Icons.abc_sharp),
                      labelText: "Workstations Config Name",
                    ),
                    validator: (value) {
                      return null;
                    },
                    onChanged: (val) {
                      _onTextFormUpdate(val, "_WS_CONFIG");
                    },
                  ),
                ],
              ),
            ),
          ),
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
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  _deployTemplate(Template template) async {
    if (!_key.currentState!.validate()) {
      return;
    }

    setState(() {
      _building = true;
      _buildingTrigger = false;
      _cloudBuildDetails = {};
      _cloudBuildTriggerDetails = {};
      _buildDone = false;

      _appName = _formFieldValues["_APP_NAME"];
    });

    String projectId = DefaultFirebaseOptions.currentPlatform.projectId;

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
            projectId: DefaultFirebaseOptions.currentPlatform.projectId,
            cloudBuildId: buildConfig['build']['id'],
            cloudBuildLogUrl: buildConfig['build']['logUrl'],
            params: _formFieldValues,
            deploymentDate: DateTime.now(),
            workstationCluster: _formFieldValues.containsKey("_WS_CLUSTER")
                ? _formFieldValues["_WS_CLUSTER"]
                : "",
            workstationConfig: _formFieldValues.containsKey("_WS_CONFIG")
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
        setState(() {
          _building = false;
          _errorMessage = "Request failed";
        });
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(param.label),
        Row(
          children: [
            param.display == false
                ? Container()
                : param.param == "_INSTANCE_GIT_REPO_OWNER"
                    ? Column(
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
                              _gitOwnerDropdown(),
                              Text(" / "),
                              Text("${_appId}")
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            width: 400.0,
                            child: TextFormField(
                                maxLength: 30,
                                initialValue: (param.param == "_REGION")
                                    ? dotenv.get("DEFAULT_REGION")
                                    : "",
                                decoration: InputDecoration(
                                  icon: Icon(Icons.abc_sharp),
                                  //hintText: param.description,
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
                                    tmpValue = tmpValue
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

                                    final validCharacters =
                                        RegExp(r'^[a-z0-9\-]+$');

                                    if (tmpValue == "" ||
                                        validCharacters.hasMatch(tmpValue)) {
                                      setState(() {
                                        _appId = tmpValue;
                                      });
                                    }
                                  }

                                  _onTextFormUpdate(val, param.param);
                                }),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 400.0,
                            child: appId,
                          ),
                        ],
                      ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
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

  _gitOwnerDropdown() {
    return Container(
        child: Column(
      children: [
        GitOwnersDropdown(onTextFormUpdate: _onTextFormUpdate),
      ],
    ));
  }
}
