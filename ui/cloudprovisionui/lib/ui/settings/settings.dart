import 'package:cloudprovision/blocs/app/app_bloc.dart';
import 'package:cloudprovision/ui/settings/switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
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
  Widget build(BuildContext parentContext) {
    return BlocBuilder<AppBloc, AppState>(builder: (parentContext, state) {
      return Container(
        padding: EdgeInsets.all(24),
        child: DefaultTabController(
          length: 3,
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
                    int GIT_HUB_TAB_INDEX = 1;
                    if (index == GIT_HUB_TAB_INDEX) {
                      BlocProvider.of<AppBloc>(parentContext)
                          .add(GetAppState());
                    }
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
                    Container(
                      child: Tab(
                          child: Text(
                        "Integrations",
                        style: textStyle,
                      )),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _generalTab(parentContext),
                      _apisTab(parentContext, state),
                      _integrationsTab(parentContext, state),
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
                            DataCell(Text(dotenv.get('PROJECT_ID'))),
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

  _apisTab(BuildContext context, AppState state) {
    _gcpTemplateGitRepository = state.gcpTemplateGitRepository;
    _instanceGitUsername = state.instanceGitUsername;
    _instanceGitToken = state.instanceGitToken;
    _gcpApiKey = state.gcpApiKey;
    _customerTemplateGitRepository = state.customerTemplateGitRepository;

    TextEditingController _gcpApiKeyController = TextEditingController();
    TextEditingController _urlCustomerRepoController = TextEditingController();
    TextEditingController _urlCommunityRepoController = TextEditingController();
    TextEditingController _urlGcpRepoController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _tokenController = TextEditingController();

    _urlCustomerRepoController.text = state.customerTemplateGitRepository;
    _urlCommunityRepoController.text = state.communityTemplateGitRepository;
    _urlGcpRepoController.text = state.gcpTemplateGitRepository;
    _usernameController.text = state.instanceGitUsername;
    _tokenController.text = state.instanceGitToken;
    _gcpApiKeyController.text = state.gcpApiKey;

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
                                          initialValue:
                                              state.gcpTemplateGitRepository,
                                          //controller: _urlController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Google Templates Repository (Read-only)",
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
                                    TemplateRepoSwitch(),
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
                                          initialValue: state
                                              .communityTemplateGitRepository,
                                          //controller: _urlController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Community Templates Repository (Read-only)",
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return fieldIsRequired;
                                            }
                                            return null;
                                          },
                                          onChanged: (val) {
                                            _communityTemplateGitRepository =
                                                val;
                                          }),
                                    ),
                                    TemplateRepoSwitch(),
                                  ],
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                    controller: _urlCustomerRepoController,
                                    decoration: InputDecoration(
                                      labelText:
                                          "Customer Templates Repository",
                                    ),
                                    validator: (value) {
                                      // if (value == null || value.isEmpty) {
                                      //   return fieldIsRequired;
                                      // }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _customerTemplateGitRepository = val;
                                    }),
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
                                      {_updateGitConfiguration(context)},
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

  _integrationsTab(BuildContext context, AppState state) {
    _castRESTAPI = state.castAPI;
    _castUserToken = state.castAccessToken;

    TextEditingController _urlController = TextEditingController();
    TextEditingController _tokenController = TextEditingController();

    _urlController.text = state.castAPI;
    _tokenController.text = state.castAccessToken;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 35.0, top: 30.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                child: Card(
                  elevation: 5,
                  child: SizedBox(
                    width: 350,
                    height: 350,
                    child: Container(
                      child: Form(
                        key: _keyCASTForm,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'images/website-cast-highlight-logo.png'),
                                  fit: BoxFit.cover,
                                ),
                                TextFormField(
                                    controller: _urlController,
                                    decoration: InputDecoration(
                                      labelText: "CAST Highlight REST API",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return fieldIsRequired;
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _castRESTAPI = val;
                                    }),
                                SizedBox(height: 30),
                                TextFormField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: _tokenController,
                                    decoration: InputDecoration(
                                      labelText: "User Access Token",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return fieldIsRequired;
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      _castUserToken = val;
                                    }),
                                SizedBox(height: 30),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: const Text('Enable Integration'),
                                  onPressed: () =>
                                      {_updateCASTConfiguration(context)},
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
            ],
          ),
        ),
      ),
    );
  }

  _updateGitConfiguration(BuildContext context) {
    if (!_keyGitForm.currentState!.validate()) {
      return;
    }

    BlocProvider.of<AppBloc>(context).add(
      SettingsChanged(_customerTemplateGitRepository, _instanceGitUsername,
          _instanceGitToken, _gcpApiKey),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(25.0),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Configuration was updated."),
    ));
  }

  _updateCASTConfiguration(BuildContext context) {
    if (!_keyCASTForm.currentState!.validate()) {
      return;
    }

    BlocProvider.of<AppBloc>(context).add(
      CastSettingsChanged(_castRESTAPI, _castUserToken),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(25.0),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text("Integration was enabled."),
    ));
  }
}
