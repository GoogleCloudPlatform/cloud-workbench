import 'dart:convert';

import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:cloudprovision/modules/my_services/data/services_repository.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:cloudprovision/routing/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../firebase_options.dart';
import '../../data/build_repository.dart';
import 'package:cloud_provision_shared/catalog/models/param.dart';
import '../../../my_services/models/service.dart';
import '../../data/build_service.dart';
import '../../../../utils/styles.dart';

import 'package:cloud_provision_shared/catalog/models/template.dart';
import '../../data/template_repository.dart';
import '../../widgets/git_owners_dropdown.dart';

class CatalogConfigPage extends ConsumerStatefulWidget {
  final String catalogSource;
  final Template _template;
  CatalogConfigPage(this._template, this.catalogSource, {super.key});

  @override
  ConsumerState<CatalogConfigPage> createState() =>
      _CatalogConfigPageState(_template);
}

class _CatalogConfigPageState extends ConsumerState<CatalogConfigPage> {
  late Template _template;
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

  _CatalogConfigPageState(this._template);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(Icons.home),
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                ],
              ),
            ),
            _templateDetails(),
            _buildDetails("Creating Cloud Build Trigger...", _cloudBuildDetails,
                _building, _buildDone, _cloudBuildStatus),
            _buildDone
                ? _buildDetails(
                    "Running Cloud Build Trigger...",
                    _cloudBuildTriggerDetails,
                    _buildingTrigger,
                    _buildTriggerDone,
                    _cloudBuildTriggerStatus)
                : Container(),
          ],
        ),
      ),
    );

    //});
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
        workstationCluster: _formFieldValues["_WS_CLUSTER"],
        workstationConfig: _formFieldValues["_WS_CONFIG"]
      );

      await ref.read(servicesRepositoryProvider).addService(deployedService);

      context.go("/services");
    } else {
      setState(() {
        _building = false;
        _errorMessage = "Request failed";
      });
    }
  }

  Widget _dynamicParamsSection() {
    final asyncTemplateValue =
        ref.watch(templateByIdProvider(_template.id, _template.category));

    return asyncTemplateValue.when(
      data: (template) {
        return Container(
          margin: const EdgeInsets.all(8.0),
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
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            color: Colors.grey[50],
            child: Form(
              key: _key,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: template.inputs.length,
                itemBuilder: (context, index) {
                  return _buildDynamicParam(index, template.inputs[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: "state.instanceGitToken" != ""
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
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

  _buildDynamicParam(int index, Param param) {
    if (param.param == "_REGION") {
      _formFieldValues["_REGION"] = dotenv.get("DEFAULT_REGION");
    }

    Widget appId = Container();
    if (param.param == "_APP_NAME") {
      appId = Container(
        child: Row(
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

                                  _onTextFormUpdate(index, val, param.param);
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

  _templateDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text("Target GCP Project: ",
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )),
                TextButton(
                  onPressed: () async {
                    final Uri _url = Uri.parse(
                        "https://console.cloud.google.com/home/dashboard?project=${DefaultFirebaseOptions.currentPlatform.projectId}");
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Text(DefaultFirebaseOptions.currentPlatform.projectId,
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Text("Template: ",
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )),
                Text(_template.name,
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    "Description: ",
                    style: AppText.fontStyleBold,
                  ),
                  Text(
                    _template.description,
                    style: AppText.fontStyle,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Template Repo: ",
                  style: AppText.fontStyleBold,
                ),
                TextButton(
                  onPressed: () async {
                    final Uri _url = Uri.parse(_template.sourceUrl);
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
                        Uri.parse(_template.cloudProvisionConfigUrl);
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Template Parameters: ",
                style: AppText.fontStyleBold,
              ),
            ),
            _dynamicParamsSection(),
          ],
        ),
      ),
    );
  }

  _buildDetails(String title, _cloudBuildDetails, _building, _buildDone,
      _cloudBuildStatus) {
    if (_cloudBuildDetails.isEmpty)
      return _building
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Text(_errorMessage),
            );

    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text(
                title,
                style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8),
              ),
            )),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text("Build ID: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_cloudBuildDetails['build']['id'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  const Text("Project ID: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_cloudBuildDetails['build']['projectId'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  const Text("Create Time: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_cloudBuildDetails['build']['createTime'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  const Text("Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_cloudBuildStatus,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  !_buildDone
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            child: CircularProgressIndicator(),
                            height: 10.0,
                            width: 10.0,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  const Text("Log Url: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  TextButton(
                    onPressed: () async {
                      final Uri _url =
                          Uri.parse(_cloudBuildDetails['build']['logUrl']);
                      if (!await launchUrl(_url)) {
                        throw 'Could not launch $_url';
                      }
                    },
                    child: Text("Cloud Build"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _onTextFormUpdate(int index, String val, String param) async {
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
