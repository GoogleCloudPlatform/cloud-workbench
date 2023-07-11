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
