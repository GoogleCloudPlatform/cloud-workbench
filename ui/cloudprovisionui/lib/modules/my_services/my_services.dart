import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../blocs/app/app_bloc.dart';
import '../../repository/models/service.dart';
import '../../modules/my_services/my_service.dart';
import '../../utils/styles.dart';

class MyServicesPage extends StatelessWidget {
  Future<void> _dialogBuilder(BuildContext context, Service service) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MyServiceDialog(service);
      },
    );
  }

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
                          return Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                _dialogBuilder(context, services[index]);
                              },
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
                                      padding: const EdgeInsets.all(10),
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
                                                        _service(
                                                            services[index]),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "Created ${timeago.format(services[index].deploymentDate)} by",
                                                                style: AppText
                                                                    .fontStyle,
                                                              ),
                                                              // SizedBox(
                                                              //   width: 5,
                                                              // ),
                                                              // Icon(
                                                              //   Icons
                                                              //       .account_circle_sharp,
                                                              //   color: Colors
                                                              //       .blueGrey,
                                                              // ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  final Uri
                                                                      _url =
                                                                      Uri.parse(
                                                                          "");
                                                                  if (!await launchUrl(
                                                                      _url)) {
                                                                    throw 'Could not launch $_url';
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "${services[index].user}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: AppText
                                                                      .linkFontStyle,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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

  _service(Service service) {
    String serviceUrl =
        "https://console.cloud.google.com/home/dashboard?project=${service.projectId}";
    String serviceIcon = "unknown";

    String tags = service.params['tags'].toString();

    if (tags.contains("cloudrun") ||
        service.templateName.toLowerCase().contains("cloudrun")) {
      serviceUrl =
          "https://console.cloud.google.com/run/detail/${service.region}/${service.name}/metrics?project=${service.projectId}";
      serviceIcon = "cloud_run";
    }

    if (tags.contains("gke") ||
        service.templateName.toLowerCase().contains("gke")) {
      serviceUrl =
          "https://console.cloud.google.com/kubernetes/clusters/details/${service.region}/${service.name}-dev/details?project=${service.projectId}";
      serviceIcon = "google_kubernetes_engine";
    }

    if (tags.contains("pubsub") ||
        service.templateName.toLowerCase().contains("pubsub")) {
      serviceUrl =
          "https://console.cloud.google.com/cloudpubsub/topic/list?referrer=search&project=${service.projectId}";
      serviceIcon = "pubsub";
    }

    if (tags.contains("storage") ||
        service.templateName.toLowerCase().contains("storage")) {
      serviceUrl =
          "https://console.cloud.google.com/storage/browser?project=${service.projectId}&prefix=";
      serviceIcon = "cloud_storage";
    }

    if (tags.contains("cloudsql") ||
        service.templateName.toLowerCase().contains("cloudsql")) {
      serviceUrl =
          "https://console.cloud.google.com/sql/instances?referrer=search&project=${service.projectId}";
      serviceIcon = "cloud_sql";
    }

    return TextButton(
      onPressed: () async {
        final Uri _url = Uri.parse(serviceUrl);
        if (!await launchUrl(_url)) {
          throw 'Could not launch $_url';
        }
      },
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image(
              image: AssetImage('images/${serviceIcon}.png'),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          SelectableText(
            service.name,
            style: AppText.linkFontStyle,
            // overflow:
            //     TextOverflow
            //         .ellipsis,
            // maxLines: 1,
          ),
        ],
      ),
    );
  }
}
