import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_appbar.dart';
import '../../app_drawer.dart';
import '../../utils/environment.dart';
import '../../utils/project_provider.dart';
import '../auth/repositories/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  TextStyle textStyle = GoogleFonts.openSans(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8);

  final _keyGitForm = GlobalKey<FormState>();
  final _keyCASTForm = GlobalKey<FormState>();

  late String _gcpTemplateGitRepository = "";
  late String _communityTemplateGitRepository = "";
  late String _customerTemplateGitRepository = "";
  late String _instanceGitUsername = "";
  late String _instanceGitToken = "";
  late String _gcpApiKey = "";
  late String _targetProject = "Select a project";

  late String _castRESTAPI = "";
  late String _castUserToken = "";

  final String fieldIsRequired = "This field is required";

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: _getBody(context, ref),
    );
  }

  Widget _getBody(BuildContext context, WidgetRef ref) {
  final settings = ref.watch(gitSettingsProvider);

     return settings.when(
            loading: () => Text('Loading...'),
            error: (err, stack) => Text('Error: $err'),
            data: (gitSettings) {

              return Container(
                padding: EdgeInsets.all(24),
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          "Workspace settings",
                          style: GoogleFonts.openSans(
                            fontSize: 32,
                            color: Color(0xFF1b3a57),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TabBar(
                          isScrollable: true,
                          onTap: (int index) {
                          },
                          tabs: [
                            Container(
                              child: Tab(
                                  child: Text(
                                    "Workbench Config",
                                    style: textStyle,
                                  )),
                            ),
                            Container(
                              child: Tab(
                                  child: Text(
                                    "Target Project Config",
                                    style: textStyle,
                                  )),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _generalTab(context),
                              _apisTab(context, gitSettings, ref),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }

  _generalTab(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(height: 20),
                    Container(width: 800, child: Text("Your workspace"))
                  ])),
            ),
            SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 5,
                child: SizedBox(
                  width: 800,
                  height: 500,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.white,
                    ),
                    child: DataTable(
                      headingRowHeight: 10,
                      dividerThickness: 0,
                      dataRowHeight: 40,
                      columnSpacing: 0,
                      columns: [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("")),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  'Workspace name',
                                  style: TextStyle(color: Colors.black54),
                                ))),
                            DataCell(Row(
                              children: [
                                Text('Product Dev Environment'),
                                SizedBox(width: 5),
                                IconButton(
                                  icon: new Icon(
                                    Icons.edit,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            )),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  'Project ID',
                                  style: TextStyle(color: Colors.black54),
                                ))),
                            DataCell(Text(Environment.getProjectId())),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: Text(
                                  'Location',
                                  style: TextStyle(color: Colors.black54),
                                ))),
                            DataCell(Text(dotenv.get('DEFAULT_REGION'))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: new Icon(
                          Icons.delete,
                          color: Colors.black54,
                        ),
                        onPressed: () {},
                      ),
                      Text("Delete workspace"),
                    ],
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  _apisTab(BuildContext context, GitSettings settings, WidgetRef ref) {
    // _gcpTemplateGitRepository = settings.gcpTemplateGitRepository;
    _instanceGitUsername = settings.instanceGitUsername;
    _instanceGitToken = settings.instanceGitToken;
    _gcpApiKey = settings.gcpApiKey;
    _customerTemplateGitRepository = settings.customerTemplateGitRepository;
    _targetProject = settings.targetProject;

    TextEditingController _gcpApiKeyController = TextEditingController();
    TextEditingController _urlCustomerRepoController = TextEditingController();
    TextEditingController _urlCommunityRepoController = TextEditingController();
    TextEditingController _urlGcpRepoController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _tokenController = TextEditingController();
    TextEditingController _projectController = TextEditingController();

    _urlCustomerRepoController.text = settings.customerTemplateGitRepository;
    // _urlCommunityRepoController.text = settings.communityTemplateGitRepository;
    // _urlGcpRepoController.text = settings.gcpTemplateGitRepository;
    _usernameController.text = settings.instanceGitUsername;
    _tokenController.text = settings.instanceGitToken;
    _gcpApiKeyController.text = settings.gcpApiKey;
    _projectController.text = settings.targetProject == ""
        ? "Select a project"
        : settings.targetProject;

    final projectsList = ref.watch(projectsProvider);


    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(height: 20),
                    Container(width: 800, child: Text("APIs Configuration"))
                  ])),
            ),
            SizedBox(height: 10),
            Container(
              child: Center(
                child: Card(
                  elevation: 5,
                  child: SizedBox(
                    width: 800,
                    height: 650,
                    child: Container(
                      child: Form(
                        key: _keyGitForm,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 700,
                                      ),
                                      child: projectsList.when(
                                          loading: () => Container(),
                                          error: (err, stack) => Text("Failed to load projects. ${err}"),
                                          data: (projects) {
                                            if (projects.isNotEmpty) {
                                              var projectNames = projects.map<String>((e) => e.name).toList();

                                              var selectProjectText = "Select a project";
                                              return ConstrainedBox(
                                                constraints: const BoxConstraints(
                                                  maxWidth: 700,
                                                ),
                                                child: DropdownButtonFormField<String>(
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  hint: Text(selectProjectText),
                                                  // value: settings.targetProject != "" ? settings.targetProject
                                                  //     : ref.read(projectDropdownProvider.notifier).state,
                                                  value: _projectController.text,
                                                  icon: const Icon(Icons.arrow_drop_down),
                                                  style: const TextStyle(color: Colors.black),
                                                  onChanged: (String? value) {

                                                    _projectController.text = value!;
                                                    _targetProject = value!;

                                                    // ref.read(projectDropdownProvider.notifier).state =
                                                    // value!;

                                                    ref.read(projectProvider.notifier).state =
                                                        projects.where((project) => project.name == value!).first;
                                                  },
                                                  items: [selectProjectText, ...projectNames]
                                                      .map<DropdownMenuItem<String>>(
                                                          (String projectName) {
                                                        return DropdownMenuItem<String>(
                                                          value: projectName,
                                                          child: Text(projectName),
                                                        );
                                                      }).toList(),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 700,
                                      ),
                                      child: TextFormField(
                                          readOnly: true,
                                          // initialValue: settings.customerTemplateGitRepository,
                                          initialValue: "https://raw.githubusercontent.com/gitrey/cp-templates/main/catalog.json",
                                          //controller: _urlController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Catalog Repository (Read-only)",
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return fieldIsRequired;
                                            }
                                            return null;
                                          },
                                          onChanged: (val) {
                                            _gcpTemplateGitRepository = val;
                                          }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      labelText: "Git Username",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return fieldIsRequired;
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _instanceGitUsername = val;
                                    }),
                                SizedBox(height: 30),
                                TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: _tokenController,
                                    decoration: InputDecoration(
                                      labelText: "Git Personal Access Token",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return fieldIsRequired;
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _instanceGitToken = val;
                                    }),
                                SizedBox(height: 30),
                                TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: _gcpApiKeyController,
                                    decoration: InputDecoration(
                                      labelText:
                                          "GCP API Key (Restrictions: Cloud Build API)",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return fieldIsRequired;
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _gcpApiKey = val;
                                    }),
                                SizedBox(height: 30),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: const Text('Update configuration'),
                                  onPressed: () =>
                                      {_updateGitConfiguration(context, ref)},
                                ),
                                SizedBox(height: 30),
                                _enableProjectSection(context, ref),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: new Icon(
                          Icons.delete,
                          color: Colors.black54,
                        ),
                        onPressed: () {},
                      ),
                      Text("Delete configuration"),
                    ],
                  )
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  _updateGitConfiguration(BuildContext context, WidgetRef ref) {
    if (!_keyGitForm.currentState!.validate()) {
      return;
    }

    final settingRepo = ref.read(settingsRepositoryProvider);

    GitSettings gitSettings = GitSettings(
      _instanceGitUsername,
      _instanceGitToken,
      _customerTemplateGitRepository,
      _gcpApiKey,
      _targetProject,
    );

    settingRepo.updateGitSettings(gitSettings);

    ref.read(projectDropdownProvider.notifier).state = _targetProject;

    ref.invalidate(gitSettingsProvider);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(25.0),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Configuration was updated."),
    ));
  }


  bootstrapTargetProject(String projectId, WidgetRef ref) {

    final authRepo = ref.watch(authRepositoryProvider);
    ProjectService projectService = new ProjectService(authRepo.getAuthClient());

    Project project = ref.watch(projectProvider);

    if (project.name != null) {
      var apis = [
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

      var authClient = authRepo.getAuthClient();

      apis.forEach((serviceName) {
        projectService.enableAPIs(projectId, serviceName, authClient);
      });

      // This could be moved to template scripts to setup the dependencies
      projectService.createArtifactRegistry(projectId, "us-central1", "cp-repo", "DOCKER", authClient);

      projectService.grantRoles(projectId, project.projectNumber, authClient);
    }
  }

  _enableProjectSection(BuildContext context, WidgetRef ref) {
    // Project project = ref.watch(projectProvider);

    String projectId = ref.watch(projectDropdownProvider);

    return projectId == "null" || projectId == "Select a project" ?
    Text("Select a project from the dropdown to enable APIs and grant IAM roles") :
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        Theme.of(context).primaryColor,
      ),
      child: Text("Enable APIs and IAM Roles in the ${_targetProject}"),
      onPressed: () =>
      {
        bootstrapTargetProject(_targetProject, ref)
      },
    );
  }

}
