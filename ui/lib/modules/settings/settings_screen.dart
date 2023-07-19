import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app_appbar.dart';
import '../../app_drawer.dart';
import '../../utils/environment.dart';

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
                                    "General",
                                    style: textStyle,
                                  )),
                            ),
                            Container(
                              child: Tab(
                                  child: Text(
                                    "APIs",
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
                                  'Resource location',
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

    TextEditingController _gcpApiKeyController = TextEditingController();
    TextEditingController _urlCustomerRepoController = TextEditingController();
    TextEditingController _urlCommunityRepoController = TextEditingController();
    TextEditingController _urlGcpRepoController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _tokenController = TextEditingController();

    _urlCustomerRepoController.text = settings.customerTemplateGitRepository;
    // _urlCommunityRepoController.text = settings.communityTemplateGitRepository;
    // _urlGcpRepoController.text = settings.gcpTemplateGitRepository;
    _usernameController.text = settings.instanceGitUsername;
    _tokenController.text = settings.instanceGitToken;
    _gcpApiKeyController.text = settings.gcpApiKey;

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
    );

    settingRepo.updateGitSettings(gitSettings);


    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(25.0),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Configuration was updated."),
    ));
  }

}
