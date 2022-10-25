import 'dart:async';
import 'dart:convert';

import 'package:cloudprovision/blocs/app/app_bloc.dart';
import 'package:cloudprovision/ui/main/main_screen.dart';
import 'package:cloudprovision/ui/templates/bloc/template-bloc.dart';
import 'package:cloudprovision/repository/service/build_service.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:cloudprovision/repository/models/param.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloudprovision/repository/build_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TemplateConfigPage extends StatefulWidget {
  final void Function(NavigationPage page) navigateTo;
  final String catalogSource;
  final Template _template;
  TemplateConfigPage(this._template, this.navigateTo, this.catalogSource,
      {super.key});

  @override
  State<TemplateConfigPage> createState() =>
      _TemplateConfigPageState(_template);
}

class _TemplateConfigPageState extends State<TemplateConfigPage> {
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

  final TemplateBloc _templateBloc = TemplateBloc(
      templateRepository: TemplateRepository(service: TemplateService()));

  String _errorMessage = "";

  _TemplateConfigPageState(this._template);

  @override
  void initState() {
    _templateBloc.add(GetTemplate(template: _template));
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
                      Navigator.of(context).pop(false);
                      widget.navigateTo(NavigationPage.WorkspaceOverview);
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

  _deployTemplate(Template template, AppState state) async {
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

    String projectId = dotenv.get('PROJECT_ID');

    bool isCICDenabled = false;
    template.inputs.forEach((element) {
      if (element.param == "_INSTANCE_GIT_REPO_OWNER") {
        isCICDenabled = true;
      }
    });

    if (isCICDenabled) {
      _formFieldValues["_INSTANCE_GIT_REPO_OWNER"] = state.instanceGitUsername;
      _formFieldValues["_INSTANCE_GIT_REPO_TOKEN"] = state.instanceGitToken;
      _formFieldValues["_API_KEY"] = state.gcpApiKey;
    }
    _formFieldValues["_APP_ID"] = _appId;

    String buildDetails = await BuildRepository(service: BuildService())
        .deployTemplate(projectId, template, _formFieldValues);

    if (buildDetails != "") {
      Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

      _formFieldValues["tags"] = template.tags;

      final user = FirebaseAuth.instance.currentUser!;

      ServiceDeploymentRequest serviceDeployedEvent = ServiceDeploymentRequest(
        user: user.displayName!,
        userEmail: user.email!,
        serviceId: _appId,
        name: _formFieldValues["_APP_NAME"],
        owner: state.instanceGitUsername,
        instanceRepo:
            "https://github.com/${_formFieldValues["_INSTANCE_GIT_REPO_OWNER"]}/${_appId}",
        templateName: template.name,
        templateId: template.id,
        template: template,
        region: _formFieldValues["_REGION"],
        projectId: dotenv.get('PROJECT_ID'),
        cloudBuildId: buildConfig['build']['id'],
        cloudBuildLogUrl: buildConfig['build']['logUrl'],
        params: _formFieldValues,
      );

      BlocProvider.of<AppBloc>(context).add(serviceDeployedEvent);

      setState(() {
        _cloudBuildDetails = buildConfig;
        _building = false;
        _cloudBuildStatus = buildConfig['build']['status'];
      });

      Timer.periodic(Duration(seconds: 10), _checkBuildStatus);
    } else {
      setState(() {
        _building = false;
        _errorMessage = "Request failed";
      });
    }
  }

  _checkBuildStatus(Timer timer) async {
    if (_cloudBuildDetails.isNotEmpty) {
      String buildId = _cloudBuildDetails['build']['id'];
      String projectId = _cloudBuildDetails['build']['projectId'];

      String buildDetails = await BuildRepository(service: BuildService())
          .getBuildDetails(projectId, buildId);

      if (buildDetails != "") {
        Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

        if (buildConfig['status'] != "WORKING") {
          timer.cancel();

          setState(() {
            _buildDone = true;
            _cloudBuildStatus = buildConfig['status'];
          });
        }

        /*if (buildConfig['status'] == "SUCCESS") {
          String triggerRunOperation =
              await BuildRepository(service: BuildService())
                  .runTrigger(projectId, _appName);

          Map<String, dynamic> triggerOperationMap =
              jsonDecode(triggerRunOperation);

          setState(() {
            _buildingTrigger = true;
            _buildTriggerDone = false;
            _cloudBuildTriggerDetails = triggerOperationMap;
            _cloudBuildTriggerStatus = triggerOperationMap['build']['status'];
          });

          Timer.periodic(Duration(seconds: 10), _checkBuildTriggerOpStatus);
        }*/
      }
    }
  }

  Widget _dynamicParamsSection() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _templateBloc,
        child: BlocListener<TemplateBloc, TemplateState>(
          listener: (context, state) {
            if (state is TemplateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<TemplateBloc, TemplateState>(
            builder: (context, state) {
              if (state is TemplateInitial) {
                return _buildLoading();
              } else if (state is TemplateLoading) {
                return _buildLoading();
              } else if (state is TemplateLoaded) {
                return _dynamicParams(state.template);
              } else if (state is TemplateError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  _dynamicParams(Template template) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
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
                    return _buildDynamicParam(
                        index, template.inputs[index], state);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: state.instanceGitToken != ""
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        'Deploy template',
                        style: AppText.buttonFontStyle,
                      ),
                      onPressed: () => _deployTemplate(template, state),
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
    });
  }

  _buildDynamicParam(int index, Param param, AppState state) {
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
                              _gitOwnerDropdown(state),
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
                        "https://console.cloud.google.com/home/dashboard?project=${dotenv.get('PROJECT_ID')}");
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Text(dotenv.get('PROJECT_ID'),
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

  void _checkBuildTriggerOpStatus(Timer timer) async {
    if (_cloudBuildTriggerDetails.isNotEmpty) {
      String buildId = _cloudBuildTriggerDetails['build']['id'];
      String projectId = _cloudBuildTriggerDetails['build']['projectId'];

      String buildDetails = await BuildRepository(service: BuildService())
          .getBuildDetails(projectId, buildId);

      if (buildDetails != "") {
        Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

        if (buildConfig['status'] != "WORKING") {
          timer.cancel();

          setState(() {
            _buildTriggerDone = true;
            _cloudBuildTriggerStatus = buildConfig['status'];
          });
        }
      }
    }
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

  _gitOwnerDropdown(AppState state) {
    return Container(
        child: Column(
      children: [
        GitOwnersDropdownButton(onTextFormUpdate: _onTextFormUpdate),
      ],
    ));
  }
}

class GitOwnersDropdownButton extends StatefulWidget {
  const GitOwnersDropdownButton({super.key, required this.onTextFormUpdate});

  final Function onTextFormUpdate;

  @override
  State<GitOwnersDropdownButton> createState() =>
      _GitOwnersDropdownButtonState();
}

class _GitOwnersDropdownButtonState extends State<GitOwnersDropdownButton> {
  late String dropdownValue;

  _GitOwnersDropdownButtonState() {
    dropdownValue = "Select an owner";
  }

  @override
  Widget build(BuildContext parentContext) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return SizedBox(
        width: 300,
        child: DropdownButtonFormField<String>(
          validator: (value) {
            if (value == null || value.isEmpty || value == "Select an owner") {
              return 'This field is required';
            }
            return null;
          },
          hint: Text("Select an owner"),
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down),
          style: const TextStyle(color: Colors.black),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
              widget.onTextFormUpdate(1000, value!, "_INSTANCE_GIT_REPO_OWNER");
            });
          },
          items: [
            "Select an owner",
            "https://github.com/${state.instanceGitUsername}"
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      );
    });
  }
}
