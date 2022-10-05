import 'package:cloudprovision/blocs/app/app_bloc.dart';
import 'package:cloudprovision/repository/models/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyServicesPage extends StatelessWidget {
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
                  "My Services",
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                Text(
                  state.myServices.isEmpty
                      ? "You have not deployed any services yet."
                      : "",
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                state.myServices.isNotEmpty
                    ? _services(context, state.myServices)
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  _services(BuildContext context, List<Service> services) {
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
                                                            'Service name:',
                                                            style: textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final Uri _url =
                                                                Uri.parse(
                                                                    "https://console.cloud.google.com/run/detail/${services[index].region}/${services[index].name}/metrics?project=${services[index].projectId}");
                                                            if (!await launchUrl(
                                                                _url)) {
                                                              throw 'Could not launch $_url';
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 30,
                                                                height: 30,
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      'images/cloud_run.png'),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                services[index]
                                                                    .name,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            'Region:',
                                                            style: textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${services[index].region}',
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
                                                            'Project ID:',
                                                            style: textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${services[index].projectId}',
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
                                                            'Deployment Date:',
                                                            style: textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                                  'MM/d/yy, h:mm a')
                                                              .format(services[
                                                                      index]
                                                                  .deploymentDate),
                                                          style: textTheme
                                                              .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  const SizedBox(width: 12),
                                                ],
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
                                                    Text("Repository:"),
                                                    const SizedBox(height: 4),
                                                    TextButton(
                                                      onPressed: () async {
                                                        final Uri _url =
                                                            Uri.parse(services[
                                                                    index]
                                                                .instanceRepo);
                                                        if (!await launchUrl(
                                                            _url)) {
                                                          throw 'Could not launch $_url';
                                                        }
                                                      },
                                                      child: Text(
                                                        services[index]
                                                            .instanceRepo,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image(
                                                              color:
                                                                  Colors.white,
                                                              image: AssetImage(
                                                                  'images/cloud_shell.png'),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                "DEVELOP IN GOOGLE CLOUD SHELL",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                      onPressed: () async {
                                                        final Uri _url = Uri.parse(
                                                            "https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=${services[index].instanceRepo}");
                                                        if (!await launchUrl(
                                                            _url)) {
                                                          throw 'Could not launch $_url';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          Text("Template:"),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: Text(
                                              "${services[index].templateName}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                          Divider(),
                                          Text("Cloud Build:"),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(
                                              end: 20,
                                            ),
                                            child: services[index]
                                                        .cloudBuildLogUrl !=
                                                    ""
                                                ? TextButton(
                                                    onPressed: () async {
                                                      final Uri _url = Uri
                                                          .parse(services[index]
                                                              .cloudBuildLogUrl);
                                                      if (!await launchUrl(
                                                          _url)) {
                                                        throw 'Could not launch $_url';
                                                      }
                                                    },
                                                    child: Text(
                                                      "Build Log",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  )
                                                : Text(
                                                    "Build log is not available."),
                                          ),
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
                        itemCount: services.length),
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
