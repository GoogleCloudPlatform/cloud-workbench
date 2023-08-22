import 'package:cloudprovision/modules/my_services/widgets/workstation_widget.dart';
import 'package:cloudprovision/widgets/summary_item.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../app_appbar.dart';
import '../../app_drawer.dart';
import 'data/services_repository.dart';

import 'models/service.dart';

import 'widgets/build_history_widget.dart';
import 'widgets/button_launch_in_cloud_shell.dart';
import 'widgets/recommendations_widget.dart';
import 'widgets/service_resources_widget.dart';
import 'widgets/service_summary.dart';
import 'widgets/template_details_widget.dart';
import 'widgets/vulnerabilities.dart';

class ServiceDetail extends ConsumerStatefulWidget {
  final String _serviceID;

  ServiceDetail(this._serviceID, {super.key});

  @override
  ConsumerState<ServiceDetail> createState() => _ServiceDetailState(_serviceID);
}

class _ServiceDetailState extends ConsumerState<ServiceDetail> {
  final String serviceID;

  _ServiceDetailState(this.serviceID);

  bool _serviceUses(Service service, List<String> types) {
    for (int i = 0; i < types.length; i++) {
      if (service.params['tags'].toString().toLowerCase().contains(
            types[i].toLowerCase(),
          )) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(serviceByDocIdProvider(serviceID));
    return asyncValue.when(
      loading: () {
        return Container();
      },
      data: (service) {
        return Scaffold(
          appBar: App_AppBar(),
          drawer: AppDrawer(),
          body: _buildPage(context, service),
        );
      },
      error: (err, st) {
        print("${st}");
        return Scaffold(body: Text("Error"));
      },
    );
  }

  Widget _buildPage(BuildContext context, Service service) {
    return Stack(
      children: [
        _buildSubHead(context),
        Positioned(
          top: 50,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${service.name}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 12),
                    _buildDetailsSection(service, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSubHead(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.black38),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 32,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    context.go('/services');
                  },
                  child: Text(
                    'My Services',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '/',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Service Detail",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Divider(color: Colors.black38),
      ],
    );
  }

  Widget _buildDetailsSection(Service service, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // <<  SERVICE SUMMARY  >>
            ServiceSummary(service: service),
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //   << REPO LINK >>
            SummaryItem(
              label: "Repository",
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline),
                  text: service.instanceRepo,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      launchUrl(Uri.parse(service.instanceRepo));
                    },
                ),
              ),
            ),
          ],
        ),
        Divider(),
        //   << CLOUD SHELL || WORKSTATION BUTTON >>

        service.workstationConfig.isNotEmpty
            ? WorkStationWidget(service)
            : LaunchInCloudShellButton(service: service),
        Divider(),
        //   << VULNERABILITIES >>

        VulnerabilityWidget(service: service),
        Divider(),

        //   << RECOMMENDATIONS >>
        if (_serviceUses(service, ["cloudrun"]))
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
            await ref.read(servicesRepositoryProvider).deleteService(service);
            ref.invalidate(servicesProvider);
            //Navigator.of(context).pop();
            context.go("/services");
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
