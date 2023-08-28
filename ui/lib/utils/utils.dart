import 'package:cloudprovision/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modules/my_services/models/service.dart';

getServiceLink(Service service) {
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

getIconImage(String string) {
  String serviceIcon = "unknown";

  if (string.contains("cloudrun")) {
    serviceIcon = "cloud_run";
  }

  if (string.contains("gke")) {
    serviceIcon = "google_kubernetes_engine";
  }

  if (string.contains("pubsub")) {
    serviceIcon = "pubsub";
  }

  if (string.contains("storage")) {
    serviceIcon = "cloud_storage";
  }

  if (string.contains("cloudsql")) {
    serviceIcon = "cloud_sql";
  }

  if (string.contains("workstations")) {
    serviceIcon = "workstations";
  }
  return serviceIcon;
}
