import 'package:cloudprovision/blocs/app/app_bloc.dart';
import 'package:cloudprovision/repository/models/cast_application.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/ui/templates/template_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CastHighlightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CAST Highlight",
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                state.castAccessToken != ""
                    ? ElevatedButton(
                        onPressed: () {
                          int campaignId = 4;
                          BlocProvider.of<AppBloc>(context).add(
                            LoadCastAssessment(
                                campaignId, state.castAccessToken),
                          );
                        },
                        child: Text("Load Assessment Recommendations"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      )
                    : Text(
                        "Please configure CAST Access Token in the Settings / Integration section",
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Color(0xFF1b3a57),
                          fontWeight: FontWeight.w600,
                        )),
                state.castApplications.isNotEmpty
                    ? _castApplications(context, state.castApplications)
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  _castApplications(
      BuildContext context, List<CastApplication> castApplications) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
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
                ])),
          ),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 800,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var service = {};
                          return Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              hoverColor: Color(0xFFF1F3F4),
                              // splashColor: Color(0xFFF1F3F4),
                              highlightColor: Colors.transparent,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: 1000,
                                        maxHeight: constraints.maxHeight),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'Application name:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${castApplications[index].name}',
                                                          style: textTheme
                                                              .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'Application details:',
                                                            style: textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final Uri _url =
                                                                Uri.parse(
                                                                    "https://demo.casthighlight.com/#Explore/Applications/${castApplications[index].id}/CloudReady");
                                                            if (!await launchUrl(
                                                                _url)) {
                                                              throw 'Could not launch $_url';
                                                            }
                                                          },
                                                          child: Text(
                                                              "CAST Highlight Portal"),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "CAST Recommendations",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Column(
                                                      children: [
                                                        for (var rec
                                                            in castApplications[
                                                                    index]
                                                                .recommendations)
                                                          Row(
                                                            children: [
                                                              Text(rec.name),
                                                              SizedBox(
                                                                height: 4,
                                                              )
                                                            ],
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Cloud Provision Catalog",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Column(
                                                      children: [],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const SizedBox(height: 4),
                                                    Column(
                                                      children: [
                                                        Text(
                                                            "Cloud Run Template"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [],
                                              ),
                                              Column(
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons
                                                            .wind_power_outlined),
                                                        const SizedBox(
                                                            width: 5),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: 170,
                                                            child: Center(
                                                              child: Text(
                                                                  "CREATE CLOUD RUN SERVICE",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    onPressed: () async {
                                                      Template template =
                                                          Template(
                                                        1,
                                                        "Onboard Go application - Cloud Run",
                                                        "Onboard Go application - Cloud Run",
                                                        "https://github.com/gitrey/cp-templates/tree/main/go-app",
                                                        "https://raw.githubusercontent.com/gitrey/cp-templates/main/go-app/cloudprovision.json",
                                                        [],
                                                      );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return TemplateConfigPage(
                                                                template);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    const SizedBox(height: 4),
                                                    Column(
                                                      children: [
                                                        Text("GKE Template"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [],
                                              ),
                                              Column(
                                                children: [
                                                  Text(""),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons
                                                            .account_tree_outlined),
                                                        const SizedBox(
                                                            width: 5),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: SizedBox(
                                                            width: 170,
                                                            child: Center(
                                                              child: Text(
                                                                  "CREATE GKE SERVICE",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () async {},
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Divider(),
                                          Text(
                                            "Workshops",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("Cloud Run:"),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "http://go/enterprise-serverless");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child:
                                                  Text("Enterprise Serverless"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("GKE:"),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "http://go/mcp-workshop");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Managed Container Platform Workshop"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "http://go/gke-optimization");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "GKE Optimization Workshop"),
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            "Reference Guides",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("Cloud Run:"),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-java-service");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Deploy a Java service to Cloud Run"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "https://cloud.google.com/architecture/microservices-architecture-refactoring-monoliths?hl=en");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Refactoring a monolith into microservices"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text("GKE:"),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "https://cloud.google.com/kubernetes-engine/docs/concepts/migration");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Migrate workloads to GKE"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "https://cloud.google.com/architecture/designing-multi-tenant-architectures?hl=en");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Designing multi-tenant architectures"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                final Uri _url = Uri.parse(
                                                    "https://cloud.google.com/architecture/prep-kubernetes-engine-for-prod?hl=en");
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              child: Text(
                                                  "Preparing a Google Kubernetes Engine environment for production"),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 4),
                        itemCount: castApplications.length),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
