import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/styles.dart';

import '../../catalog/data/build_repository.dart';
import '../../catalog/models/build.dart';
import '../models/service.dart';

class BuildHistoryWidget extends ConsumerStatefulWidget {
  const BuildHistoryWidget({
    super.key,
    required Service service,
  }) : service = service;

  final Service service;

  @override
  ConsumerState<BuildHistoryWidget> createState() => _BuildHistoryWidgetState();
}

class _BuildHistoryWidgetState extends ConsumerState<BuildHistoryWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var triggerBuilds = ref.watch(triggerBuildsProvider(
        projectId: widget.service.projectId,
        serviceId: widget.service.serviceId));

    return triggerBuilds.when(
      loading: () => LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (builds) {
        String triggerId = "";

        if (builds.isNotEmpty) {
          triggerId = builds.first.buildTriggerId;
        }

        return Column(
          children: [
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
                        "https://console.cloud.google.com/cloud-build/triggers?project=${widget.service.projectId}");
                    if (builds.isNotEmpty) {
                      _url = Uri.parse(
                          "https://console.cloud.google.com/cloud-build/triggers;region=global/edit/${triggerId}?project=${widget.service.projectId}");
                    }

                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Text(
                    "${widget.service.serviceId}-webhook-trigger",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.linkFontStyle,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () async {
                    Uri _url = Uri.parse(
                        "https://console.cloud.google.com/cloud-build/triggers?project=${widget.service.projectId}");
                    if (builds.isNotEmpty) {
                      _url = Uri.parse(
                          "https://console.cloud.google.com/cloud-build/builds;region=global?query=trigger_id=${triggerId}&project=${widget.service.projectId}");
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
            buildCloudBuildsSection(builds),
          ],
        );
      },
    );


  }

  buildCloudBuildsSection(var triggerBuilds) {
    List<Widget> rows = [];
    for (Build build in triggerBuilds) {
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
            "(${timeago.format(widget.service.deploymentDate)})",
            style: AppText.fontStyle,
          ),
        ],
      ));
    }
    return Column(
      children: rows,
    );
  }
}
