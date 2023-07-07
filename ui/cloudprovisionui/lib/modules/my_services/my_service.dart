import 'package:cloudprovision/modules/my_services/widgets/workstation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../app_appbar.dart';
import '../../app_drawer.dart';
import 'data/services_repository.dart';

import 'models/service.dart';

import '../../utils/styles.dart';
import 'widgets/build_history_widget.dart';
import 'widgets/button_launch_in_cloud_shell.dart';
import 'widgets/recommendations_widget.dart';
import 'widgets/service_resources_widget.dart';
import 'widgets/service_summary.dart';
import 'widgets/template_details_widget.dart';
import 'widgets/vulnerabilities.dart';

class MyServiceDialog extends ConsumerStatefulWidget {
  final Service _service;

  MyServiceDialog(this._service, {super.key});

  @override
  ConsumerState<MyServiceDialog> createState() =>
      _MyServiceDialogState(_service);
}

class _MyServiceDialogState extends ConsumerState<MyServiceDialog> {
  final Service service;

  _MyServiceDialogState(this.service);

  bool _serviceUses(List<String> types) {
    for (int i = 0; i < types.length; i++) {
      if (service.params['tags'].toString().toLowerCase().contains(
            types[i].toLowerCase(),
          )) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(100),
          padding: EdgeInsets.all(25),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // <<  SERVICE SUMMARY  >>
                  ServiceSummary(service: service),

                  // << CLOSE BUTTON >>
                  IconButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                    ),
                    tooltip: "Close",
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //   << REPO LINK >>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Repository:"),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () async {
                          launchUrl(Uri.parse(service.instanceRepo));
                        },
                        child: Text(
                          service.instanceRepo,
                          style: AppText.linkFontStyle,
                        ),
                      ),
                    ],
                  ),

                  //   << CLOUD SHELL BUTTON >>
                  LaunchInCloudShellButton(service: service),
                ],
              ),
              Divider(),
              service.workstationCluster.isNotEmpty
                  ? WorkStationWidget(service) : Container(),
              Divider(),

              //   << VULNERABILITIES >>

              VulnerabilityWidget(service: service),
              Divider(),

              //   << RECOMMENDATIONS >>
              if (_serviceUses(["cloudrun"]))
                RecommendationsWidget(service: service),
              Divider(),

              //   << BUILD HISTORY >>
              BuildHistoryWidget(service: service),

              //   << RESOURCES >>
              ServiceResourcesWidget(service: service),

              //   << TEMPLATE DETAILS >>
              TemplateDetailsWidget(service: service),
              Divider(),

              // <<  DELETE BUTTON  >>
              IconButton(
                tooltip: 'Delete',
                onPressed: () async {
                  await ref
                      .read(servicesRepositoryProvider)
                      .deleteService(service);
                  ref.invalidate(servicesProvider);
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
