import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../repository/build_repository.dart';
import '../../repository/models/build.dart';
import '../../repository/models/metadata_model.dart';
import '../../repository/models/recommendation_insight.dart';
import '../../repository/models/service.dart';
import '../../repository/models/vulnerability.dart';
import '../../repository/security_repository.dart';
import '../../repository/service/build_service.dart';
import '../../repository/service/security_service.dart';
import '../../repository/service/template_service.dart';
import '../../repository/template_repository.dart';
import '../../ui/templates/bloc/template-bloc.dart';
import '../../utils/styles.dart';

class MyServiceDialog extends StatefulWidget {
  final Service _service;

  MyServiceDialog(this._service, {super.key});

  @override
  State<MyServiceDialog> createState() => _MyServiceDialogState(_service);
}

class _MyServiceDialogState extends State<MyServiceDialog> {
  final Service service;

  final TemplateBloc _templateBloc = TemplateBloc(
      templateRepository: TemplateRepository(service: TemplateService()));

  _MyServiceDialogState(this.service);

  List<Build> _triggerBuilds = [];
  List<Vulnerability> _vulnerabilities = [];
  List<RecommendationInsight> _recommendations = [];
  bool _loadingTriggerBuilds = false;
  bool _loadingVulnerabilities = false;
  bool _loadingRecommendationsInsights = false;
  late String _triggerId;

  @override
  void initState() {
    _loadingTriggerBuilds = true;
    _loadingVulnerabilities = true;
    _loadingRecommendationsInsights = true;

    loadTriggerBuilds();
    loadVulnerabilities();
    loadRecommendationsInsights();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(100),
        padding: EdgeInsets.all(25),
        color: Colors.white,
        child: Column(
          children: [
            _serviceDetails(service, context),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Close',
                style: AppText.linkFontStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
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
          "https://console.cloud.google.com/run/detail/${service.region}/${service.serviceId}/metrics?project=${service.projectId}";
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

  _serviceDetails(Service service, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                  Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          'Service name:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      _service(service),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Service ID:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${service.serviceId}',
                        style: AppText.fontStyle,
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
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${service.region}',
                        style: AppText.fontStyle,
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
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${service.projectId}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Last deployed:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        DateFormat('MM/d/yy, h:mm a')
                            .format(service.deploymentDate),
                        style: AppText.fontStyle,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "(${timeago.format(service.deploymentDate)})",
                        style: AppText.fontStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Deployed by:',
                          style: AppText.fontStyleBold,
                        ),
                      ),
                      Text(
                        '${service.user}',
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {},
                // ),
                // IconButton(
                //   icon: Icon(
                //     Icons.more_vert,
                //   ),
                //   onPressed: () {},
                // ),
                // const SizedBox(width: 12),
              ],
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Repository:",
                    style: AppText.fontStyleBold,
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () async {
                      final Uri _url = Uri.parse(service.instanceRepo);
                      if (!await launchUrl(_url)) {
                        throw 'Could not launch $_url';
                      }
                    },
                    child: Text(
                      service.instanceRepo,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppText.linkFontStyle,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image(
                            color: Colors.white,
                            image: AssetImage('images/cloud_shell.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("DEVELOP IN GOOGLE CLOUD SHELL",
                              style: AppText.buttonFontStyle),
                        )
                      ],
                    ),
                    onPressed: () async {
                      final Uri _url = Uri.parse(
                          "https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=${service.instanceRepo}&cloudshell_workspace=.");
                      if (!await launchUrl(_url)) {
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
        Row(
          children: [
            Text(
              "Vulnerabilities: ",
              style: AppText.fontStyleBold,
            ),
          ],
        ),
        const SizedBox(height: 4),
        _loadingVulnerabilities
            ? LinearProgressIndicator()
            : buildVulnerabilitiesSection(service.serviceId),
        Divider(),
        Row(
          children: [
            Text(
              "Recommendations and Insights: ",
              style: AppText.fontStyleBold,
            ),
          ],
        ),
        const SizedBox(height: 4),
        _loadingRecommendationsInsights
            ? LinearProgressIndicator()
            : buildRecommendationsSection(),
        Divider(),
        Row(
          children: [
            Text(
              "Build History: ",
              style: AppText.fontStyleBold,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () async {
                Uri _url = Uri.parse(
                    "https://console.cloud.google.com/cloud-build/triggers?project=${service.projectId}");
                if (_triggerBuilds.isNotEmpty) {
                  _url = Uri.parse(
                      "https://console.cloud.google.com/cloud-build/triggers;region=global/edit/${_triggerId}?project=${service.projectId}");
                }

                if (!await launchUrl(_url)) {
                  throw 'Could not launch $_url';
                }
              },
              child: Text(
                "${service.serviceId}-webhook-trigger",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppText.linkFontStyle,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () async {
                Uri _url = Uri.parse(
                    "https://console.cloud.google.com/cloud-build/triggers?project=${service.projectId}");
                if (_triggerBuilds.isNotEmpty) {
                  _url = Uri.parse(
                      "https://console.cloud.google.com/cloud-build/builds;region=global?query=trigger_id=${_triggerId}&project=${service.projectId}");
                }

                if (!await launchUrl(_url)) {
                  throw 'Could not launch $_url';
                }
              },
              child: Text(
                "View All",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppText.linkFontStyle,
              ),
            )
          ],
        ),
        const SizedBox(height: 4),
        _loadingTriggerBuilds
            ? LinearProgressIndicator()
            : buildCloudBuildsSection(),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ExpansionTile(
                title: Text(
                  'Resources (ref guides, codelabs, etc):',
                  style: AppText.fontStyleBold,
                ),
                children: <Widget>[
                  for (TemplateMetadata tm in service.template!.metadata)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            final Uri _url = Uri.parse(tm.value);
                            if (!await launchUrl(_url)) {
                              throw 'Could not launch $_url';
                            }
                          },
                          child: Text(
                            tm.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppText.linkFontStyle,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ExpansionTile(
                title: Text(
                  'Template:',
                  style: AppText.fontStyleBold,
                ),
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "${service.templateName}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${service.template?.version}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${service.template?.owner}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        DateFormat('MM/d/yy, h:mm a').format(DateTime.parse(
                            "${service.template?.lastModified}")),
                        style: AppText.fontStyle,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "(${timeago.format(DateTime.parse("${service.template?.lastModified}"))})",
                        style: AppText.fontStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void loadTriggerBuilds() async {
    List<Build> builds = await BuildRepository(service: BuildService())
        .getTriggerBuilds(service.projectId, service.serviceId);

    setState(() {
      if (builds.isNotEmpty) {
        _triggerId = builds.first.buildTriggerId;
      }
      _triggerBuilds = builds;
      _loadingTriggerBuilds = false;
    });
  }

  void loadVulnerabilities() async {
    List<Vulnerability> vulnerabilities =
        await SecurityRepository(service: SecurityService())
            .getContainerVulnerabilities(service.projectId, service.serviceId);

    setState(() {
      _vulnerabilities = vulnerabilities;
      _loadingVulnerabilities = false;
    });
  }

  void loadRecommendationsInsights() async {
    List<RecommendationInsight> recommendations =
        await SecurityRepository(service: SecurityService())
            .getSecurityRecommendations(service.projectId, service.serviceId);

    setState(() {
      _recommendations = recommendations;
      _loadingRecommendationsInsights = false;
    });
  }

  buildCloudBuildsSection() {
    List<Widget> rows = [];
    for (Build build in _triggerBuilds) {
      rows.add(Row(
        children: [
          build.status == "SUCCESS"
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            width: 80,
            child: Text(
              build.status == "SUCCESS" ? "Successful" : "Failed",
              style: AppText.fontStyle,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          TextButton(
            onPressed: () async {
              final Uri _url = Uri.parse(build.buildLogUrl);
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Text(
              build.buildId.substring(0, 8),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.linkFontStyle,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            DateFormat('MM/d/yy, h:mm a')
                .format(DateTime.parse(build.createTime)),
            style: AppText.fontStyle,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            "(${timeago.format(service.deploymentDate)})",
            style: AppText.fontStyle,
          ),
        ],
      ));
    }
    return Column(
      children: rows,
    );
  }

  buildVulnerabilitiesSection(String serviceId) {
    var vulnerabilitiesMap = {};

    _vulnerabilities.forEach((vuln) {
      if (vulnerabilitiesMap.containsKey(vuln.resourceUri)) {
        List<Map<String, String>> vulnList =
            vulnerabilitiesMap[vuln.resourceUri];

        Map<String, String> tmpVulnMap = {};
        tmpVulnMap['fixableCount'] = vuln.fixableCount;
        tmpVulnMap['totalCount'] = vuln.totalCount;
        tmpVulnMap['severity'] = vuln.severity;
        vulnList.add(tmpVulnMap);
      } else {
        List<Map<String, String>> tmpVulnList = [];
        vulnerabilitiesMap[vuln.resourceUri] = tmpVulnList;

        Map<String, String> tmpVulnMap = {};
        tmpVulnMap['fixableCount'] = vuln.fixableCount;
        tmpVulnMap['totalCount'] = vuln.totalCount;
        tmpVulnMap['severity'] = vuln.severity;

        tmpVulnList.add(tmpVulnMap);
      }
    });

    List<Widget> rows = [];

    vulnerabilitiesMap.entries.forEach((element) {
      String name = element.key as String;
      name = name.substring(
          name.indexOf("sha256:") + 7, name.indexOf("sha256:") + 7 + 12);
      rows.add(Row(
        children: [
          Text(
            "Container: ",
            style: AppText.fontStyle,
          ),
          SizedBox(
            width: 4,
          ),
          TextButton(
            onPressed: () async {
              final Uri _url = Uri.parse(element.key as String);
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Text(
              "${serviceId}@${name}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.linkFontStyle,
            ),
          ),
        ],
      ));

      rows.add(Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "Severity",
              style: AppText.fontStyleBold,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            width: 100,
            child: Text(
              "Total",
              style: AppText.fontStyleBold,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            child: Text(
              "Fixable",
              style: AppText.fontStyleBold,
            ),
          ),
        ],
      ));

      List<Map<String, String>> mv = element.value;
      mv.forEach((el) {
        rows.add(Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(
                "${el['severity']}",
                style: AppText.fontStyle,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            SizedBox(
              width: 110,
              child: Text(
                "${el['totalCount']}",
                style: AppText.fontStyle,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            SizedBox(
              child: Text(
                "${el['fixableCount']}",
                style: AppText.fontStyle,
              ),
            ),
          ],
        ));
      });
    });

    return Column(
      children: rows,
    );
  }

  buildRecommendationsSection() {
    List<Widget> rows = [];
    for (RecommendationInsight rec in _recommendations) {
      rows.add(Row(
        children: [
          Text(
            "Insight:",
            style: AppText.fontStyleBold,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            rec.insightDescription,
            style: AppText.fontStyle,
          ),
        ],
      ));

      rows.add(Row(
        children: [
          Text(
            "Recommendation:",
            style: AppText.fontStyleBold,
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
            child: Text(
              rec.recommendationDescription,
              style: AppText.fontStyle,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          TextButton(
            onPressed: () async {
              final Uri _url = Uri.parse(rec.recommendationActionValue);
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
            child: Text(
              "Fix it",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppText.linkFontStyle,
            ),
          ),
        ],
      ));
    }
    return Column(
      children: rows,
    );
  }
}
