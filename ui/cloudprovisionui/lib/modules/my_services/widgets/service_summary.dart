import 'package:cloudprovision/modules/my_services/models/service.dart';
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
        Row(
          children: [
            SelectableText('Service name: ${service.name}'),
            //_service(service),
          ],
        ),
        Row(
          children: [
            SelectableText('Service ID: ${service.serviceId}'),
          ],
        ),
        Row(
          children: [
            SelectableText('Region: ${service.region}'),
          ],
        ),
        Row(
          children: [
            SelectableText('Project ID: ${service.projectId}'),
          ],
        ),
        Row(
          children: [
            SelectableText('Workstation Cluster: ${service.workstationCluster}'),
          ],
        ),
        Row(
          children: [
            Text('Workstation Config: ${service.workstationConfig}'),
          ],
        ),
        Row(
          children: [
            SelectableText('Last Deployed:'),
            SelectableText(DateFormat('MM/d/yy, h:mm a').format(service.deploymentDate)),
            SelectableText("(${timeago.format(service.deploymentDate)})")
          ],
        ),
        Row(
          children: [
            SelectableText('Deployed by: ${service.user}'),
          ],
        ),
      ],
    );
  }
}
