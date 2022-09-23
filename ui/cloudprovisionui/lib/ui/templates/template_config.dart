import 'dart:async';
import 'dart:convert';

import 'package:cloudprovision/blocs/template/template-bloc.dart';
import 'package:cloudprovision/repository/service/build_service.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:cloudprovision/repository/models/param.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloudprovision/repository/build_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TemplateConfigPage extends StatefulWidget {
  final Template _template;
  TemplateConfigPage(this._template, {super.key});

  @override
  State<TemplateConfigPage> createState() =>
      _TemplateConfigPageState(_template);
}

class _TemplateConfigPageState extends State<TemplateConfigPage> {
  late Template _template;
  String _appName = "";

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
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          _templateDetails(),
          _buildDetails(
              _cloudBuildDetails, _building, _buildDone, _cloudBuildStatus),
          _buildDone
              ? _buildDetails(_cloudBuildTriggerDetails, _buildingTrigger,
                  _buildTriggerDone, _cloudBuildTriggerStatus)
              : Container(),
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

    String projectId = dotenv.get('PROJECT_ID');

    String buildDetails = await BuildRepository(service: BuildService())
        .deployTemplate(projectId, template, _formFieldValues);

    if (buildDetails != "") {
      Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

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

        if (buildConfig['status'] == "SUCCESS") {
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
        }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          color: Colors.grey[50],
          child: Form(
            key: _key,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: template.params.length,
              itemBuilder: (context, index) {
                return _buildDynamicParam(index, template.params[index]);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
            child: const Text('Deploy template'),
            onPressed: () => _deployTemplate(template),
          ),
        ),
      ],
    );
  }

  _buildDynamicParam(int index, Param param) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(param.label),
        SizedBox(
          width: 400.0,
          child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.abc_sharp),
                //hintText: param.description,
                labelText: param.label,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter value';
                }
                return null;
              },
              onChanged: (val) {
                _onTextFormUpdate(index, val, param);
              }),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  _templateDetails() {
    return Container(
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
              const Text("Target GCP Project: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
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
                    style: TextStyle(
                      fontSize: 20,
                    )),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Template: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  )),
              Text(_template.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                const Text("Description: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    )),
                Text(_template.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
          Row(
            children: [
              const Text("Template Source: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  )),
              TextButton(
                onPressed: () async {
                  final Uri _url = Uri.parse(_template.sourceUrl);
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch $_url';
                  }
                },
                child: Text("GitHub repo"),
              ),
            ],
          ),
          Row(
            children: [
              const Text("CloudBuild config: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  )),
              TextButton(
                onPressed: () async {
                  final Uri _url = Uri.parse(_template.cloudProvisionConfigUrl);
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch $_url';
                  }
                },
                child: Text("GitHub repo"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const Text("Template Parameters: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                )),
          ),
          _dynamicParamsSection(),
        ],
      ),
    );
  }

  _buildDetails(_cloudBuildDetails, _building, _buildDone, _cloudBuildStatus) {
    if (_cloudBuildDetails.isEmpty)
      return _building
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Text(_errorMessage),
            );

    return Container(
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
    );
  }

  _onTextFormUpdate(int index, String val, Param param) async {
    String key = param.param;
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
}