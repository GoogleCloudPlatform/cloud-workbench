// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloudprovision/modules/my_services/service_detail.dart';
import 'package:cloudprovision/widgets/cloud_table.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/utils.dart';

import 'models/service.dart';
import '../../modules/my_services/my_service.dart';
import 'data/services_repository.dart';

class MyServicesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildSubHead(context),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active Services",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 12),
                _buildServiceList(context: context, ref: ref),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildServiceList({required BuildContext context, required WidgetRef ref}) {
    final servicesList = ref.watch(servicesProvider);
    return servicesList.when(
      loading: () => Text('Loading...'),
      error: (err, stack) => Text('Error: $err'),
      data: (services) {
        return services.isNotEmpty
            ? _buildServicesTable(context, services)
            : Text(
                "You have not deployed any services yet.",
                style: Theme.of(context).textTheme.titleMedium,
              );
      },
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Services",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              InkWell(
                onTap: () => context.go("/catalog"),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_box,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      " CREATE SERVICE",
                      style: Theme.of(context).textTheme.bodyMedium?.merge(
                            TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.black38),
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Service service) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MyServiceDialog(service);
      },
    );
  }

  _buildServicesTable(BuildContext context, List<Service> services) {
    List<TableRow> rows = [];
    // Header Row
    rows.add(TableRow(
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.04),
      ),
      children: [
        CloudTableCell(child: CloudTableCellText(text: "Service")),
        CloudTableCell(child: CloudTableCellText(text: "Deployed Date")),
      ],
    ));

    // Map Services
    for (int i = 0; i < services.length; i++) {
      final service = services[i];

      if (!service.params['tags'].toString().contains("workstation")) {
        rows.add(
          TableRow(
            children: [
              CloudTableCell(
                  child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 15),
                  _buildServiceIcon(service),
                  _getServiceNameLink(context, service),
                ],
              )),
              CloudTableCell(
                  child: CloudTableCellText(
                      text:
                          "Created ${timeago.format(service.deploymentDate)} by ${service.user}"))
            ],
          ),
        );
      }
    }

    return CloudTable(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  _getServiceNameLink(BuildContext context, Service service) {
    return InkWell(
        child: Text(
          service.name,
          style: TextStyle(color: Colors.blue),
        ),
        // onTap: () => _dialogBuilder(context, service),

        onTap: () {
          context.go("/service/${service.id}");
        }

        // () async {
        //   final Uri _url = Uri.parse(_getServiceUrl(service));
        //   if (!await launchUrl(_url)) {
        //     throw 'Could not launch $_url';
        //   }
        // },
        );
  }

  _getServiceIcon(Service service) {
    String val = service.params['tags'].toString().toLowerCase() +
        service.templateName.toLowerCase();
    return getIconImage(val);
  }

  _getServiceUrl(Service service) {
    String serviceUrl =
        "https://console.cloud.google.com/home/dashboard?project=${service.projectId}";

    String tags = service.params['tags'].toString();

    if (tags.contains("cloudrun") ||
        service.templateName.toLowerCase().contains("cloudrun")) {
      serviceUrl =
          "https://console.cloud.google.com/run/detail/${service.region}/${service.serviceId}/metrics?project=${service.projectId}";
    }

    if (tags.contains("gke") ||
        service.templateName.toLowerCase().contains("gke")) {
      serviceUrl =
          "https://console.cloud.google.com/kubernetes/clusters/details/${service.region}/${service.serviceId}-dev/details?project=${service.projectId}";
    }

    if (tags.contains("pubsub") ||
        service.templateName.toLowerCase().contains("pubsub")) {
      serviceUrl =
          "https://console.cloud.google.com/cloudpubsub/topic/list?referrer=search&project=${service.projectId}";
    }

    if (tags.contains("storage") ||
        service.templateName.toLowerCase().contains("storage")) {
      serviceUrl =
          "https://console.cloud.google.com/storage/browser?project=${service.projectId}&prefix=";
    }

    if (tags.contains("cloudsql") ||
        service.templateName.toLowerCase().contains("cloudsql")) {
      serviceUrl =
          "https://console.cloud.google.com/sql/instances?referrer=search&project=${service.projectId}";
    }
    return serviceUrl;
  }

  _buildServiceIcon(Service service) {
    final String serviceUrl = _getServiceUrl(service);
    final serviceIcon = _getServiceIcon(service);

    return SizedBox(
        height: 15,
        child: IconButton(
          padding: EdgeInsets.only(left: 5, right: 5),
          onPressed: () async {
            final Uri _url = Uri.parse(serviceUrl);
            print(_url);
            if (!await launchUrl(_url)) {
              throw 'Could not launch $_url';
            }
          },
          icon: Image(image: AssetImage('assets/images/${serviceIcon}.png')),
        ));
  }
}
