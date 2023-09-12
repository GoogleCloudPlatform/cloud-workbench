import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:cloudprovision/modules/settings/application/project_service.dart';
import 'package:cloudprovision/modules/settings/data/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/styles.dart';
import '../../../widgets/summary_item.dart';

import 'package:cloud_provision_shared/catalog/models/template.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../settings/project_widget.dart';
import 'package:cloud_provision_shared/catalog/models/param.dart';

import '../data/template_repository.dart';
import 'cloud_workstation_widget.dart';
import 'deploy_controller.dart';
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

  Map<String, String> _formFieldValues = {};
  final _key = GlobalKey<FormState>();

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
                    onPressed: () {
                      ref.read(projectProvider.notifier).state = emptyProject;
                      Navigator.of(context).pop();
                    },
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

    final state = ref.watch(deployControllerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
                  child: Text(
                    'Deploy template',
                    style: AppText.buttonFontStyle,
                  ),
                  onPressed: ref.watch(projectProvider).name == "null" || state.isLoading ? null :
                      () => _deployTemplate(template),
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
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: SelectableText(
                          'Target Project:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Expanded(child: ProjectWidget(ref, "Select a project")),
                    ],
                  ),
                  ref.watch(projectProvider).name == "null" ? Container()
                      :_buildServiceStatus(context),
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

  Widget _buildServiceStatus(BuildContext context) {

    Project project = ref.read(projectProvider);

    var services = [
      "cloudbuild.googleapis.com",
      "workstations.googleapis.com",
      "secretmanager.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "artifactregistry.googleapis.com",
      "run.googleapis.com",
      "container.googleapis.com",
      "containeranalysis.googleapis.com",
      "recommender.googleapis.com",
      "containerscanning.googleapis.com",
    ];



    List<Widget> list = [];
    for (String service in services) {
      final serviceStatus = ref.watch(serviceStatusProvider(project: project, serviceName: service));

      list.add(Row(
        children: [
          serviceStatus.when(
          loading: () => SizedBox(
            child: CircularProgressIndicator(),
            height: 10.0,
            width: 10.0,
          ),
          error: (err, stack) => Tooltip(
            message: "Status unknown",
            child: Icon(
              Icons.question_mark,
              color: Colors.red,
            ),
          ),
          data: (enabled) {
            return  enabled == true ?
            Tooltip(
              message: "Enabled",
              child: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ) :
            Tooltip(
              message: "Disabled",
              child: Icon(
                Icons.stop_circle,
                color: Colors.amber,
              ),
            );
          }
          ),
          TextButton(
            onPressed: () async {
              final Uri _url =
              Uri.parse("https://console.cloud.google.com/apis/library/${service}?project=${project.projectId}");
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Text(
              service,
              style: AppText.linkFontStyle,
            ),
          ),
        ],
      ));
    }

    return ExpansionTile(
      initiallyExpanded: true,
      expandedAlignment: Alignment.topLeft,
      title: Text('APIs, Services and IAM Roles',
        style: AppText.fontStyleBold,),
      controlAffinity: ListTileControlAffinity.leading,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 300,
                    child: Text("This solution uses the APIs and services listed below. Click \"Bootstrap\" button to enable the ones that aren’t already enabled. You are subject to the Terms of Service of each of these and you’ll start incurring charges for products in the solution after deployment.")),
                SizedBox(height: 10,),
                ...list,
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 300,
                    child: Text("To deploy the solution, a Cloud Build service account will be granted the following roles.")),
                SizedBox(height: 10,),
                Container(color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("roles/run.admin"),
                      Text("roles/secretmanager.admin"),
                      Text("roles/iam.serviceAccountUser"),
                    ],
                  ),
                ),)
              ],
            )
          ],
        )

      ]
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
            _template.category == "application" ?
                CloudWorkstationWidget(onTextFormUpdate: _onTextFormUpdate)
                : Container(),
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

    final controller = ref.read(deployControllerProvider.notifier);
    bool success = await controller.deployTemplate(template, _formFieldValues, _appId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deployment started"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      context.go("/services");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deployment failed"),
          backgroundColor: Colors.red,
        ),
      );
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


}
