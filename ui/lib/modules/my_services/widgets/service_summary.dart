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

import 'package:cloudprovision/modules/my_services/models/service.dart';
import 'package:cloudprovision/widgets/summary_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServiceSummary extends StatelessWidget {
  final Service service;
  const ServiceSummary({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SummaryItem(label: "Service name", child: SelectableText(service.name)),
        SummaryItem(
            label: "Service ID", child: SelectableText(service.serviceId)),
        SummaryItem(label: "Region", child: SelectableText(service.region)),
        SummaryItem(
            label: "Project ID", child: SelectableText(service.projectId)),
        SummaryItem(
            label: "Workstation Cluster",
            child: SelectableText(service.workstationCluster)),
        SummaryItem(
            label: "Workstation Config",
            child: SelectableText(service.workstationConfig)),
        SummaryItem(label: "Region", child: SelectableText(service.region)),
        SummaryItem(
            label: "Last Deployed",
            child: SelectableText(
                DateFormat('MM/d/yy, h:mm a').format(service.deploymentDate) +
                    "( ${timeago.format(service.deploymentDate)})")),
        SummaryItem(label: "Deployed by", child: SelectableText(service.user)),
      ],
    );
  }
}
