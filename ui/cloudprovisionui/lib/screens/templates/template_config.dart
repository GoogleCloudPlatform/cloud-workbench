import 'dart:convert';

import 'package:cloudprovision/data/repositories/template_repository.dart';
import 'package:cloudprovision/models/param_model.dart';
import 'package:cloudprovision/models/template_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloudprovision/data/repositories/build_repository.dart';

class TemplateConfigPage extends StatefulWidget {
  final TemplateModel _template;
  TemplateConfigPage(this._template, {super.key});

  @override
  State<TemplateConfigPage> createState() =>
      _TemplateConfigPageState(_template);
}

class _TemplateConfigPageState extends State<TemplateConfigPage> {
  late TemplateModel _template;
  Map<String, dynamic> _cloudBuildDetails = {};
  final _templateRepository = TemplateRepository();

  bool _building = false;

  _TemplateConfigPageState(this._template);

  @override
  Widget build(BuildContext context) {
    // TODO switch to Stream/FutureBuilder pattern
    // if (_templates.isEmpty) {
    //   _templateRepository.loadTemplates(context).then((templates) {
    //     setState(() {
    //       _templates = templates;
    //     });
    //   });
    // }

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
          _buildDetails(),
        ],
      ),
    );
  }

  _deployTemplate(TemplateModel template, BuildContext context) async {
    setState(() {
      _building = true;
      _cloudBuildDetails = {};
    });
    String buildDetails = await BuildRepository().deployTemplate(template);

    if (buildDetails != "") {
      Map<String, dynamic> buildConfig = jsonDecode(buildDetails);

      setState(() {
        _cloudBuildDetails = buildConfig;
        _building = false;
      });
    }

    /*await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            SelectableText(
              buildDetails,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );*/

    /*final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Template deployed'),
      ),
    );*/
  }

  _params(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _template.params.length,
        itemBuilder: (context, index) {
          return _row(index, _template.params[index]);
        },
      ),
    );
  }

  _row(int index, ParamModel param) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(param.label),
        SizedBox(width: 30),
        SizedBox(
          width: 200.0,
          child: TextFormField(),
        ),
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
                Text(_template.name,
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
          _params(context),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              child: const Text('Deploy template'),
              onPressed: () => _deployTemplate(_template, context),
            ),
          ),
        ],
      ),
    );
  }

  _buildDetails() {
    if (_cloudBuildDetails.isEmpty)
      return _building ? Center(child: CircularProgressIndicator()) : Text('');

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
          Row(
            children: [
              const Text("Status: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  )),
              Text(_cloudBuildDetails['build']['status'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
