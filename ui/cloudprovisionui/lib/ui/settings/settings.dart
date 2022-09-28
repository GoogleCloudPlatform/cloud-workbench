import 'package:cloudprovision/ui/templates/bloc/template-bloc.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  TextStyle textStyle = GoogleFonts.openSans(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TemplateRepository(service: TemplateService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TemplateBloc>(
            create: (context) => TemplateBloc(
              templateRepository: context.read<TemplateRepository>(),
            )..add(GetTemplatesList()),
          ),
        ],
        child: Container(
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
                          "GitHub",
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
                        _generalTab(context),
                        _gitHubTab(context),
                        _integrationsTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                            DataCell(Text('andrey-cp-8-9')),
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
                            DataCell(Text('us-east1')),
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

  _gitHubTab(BuildContext context) {
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
                    Container(width: 800, child: Text("GitHub Configuration"))
                  ])),
            ),
            SizedBox(height: 10),
            Center(
              child: Card(
                elevation: 5,
                child: SizedBox(
                  width: 800,
                  height: 500,
                  child: Container(
                      child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                                initialValue:
                                    "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates-v2.json",
                                decoration: InputDecoration(
                                  labelText: "Template GitHub Repository",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter value';
                                  }
                                  return null;
                                },
                                onChanged: (val) {}),
                            SizedBox(height: 30),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Instance GitHub Username",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter value';
                                  }
                                  return null;
                                },
                                onChanged: (val) {}),
                            SizedBox(height: 30),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText:
                                      "Instance GitHub Personal Access Token",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter value';
                                  }
                                  return null;
                                },
                                onChanged: (val) {}),
                            SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              child: const Text('Save configuration'),
                              onPressed: () => {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
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

  _integrationsTab(BuildContext context) {
    return Text("");
  }
}
