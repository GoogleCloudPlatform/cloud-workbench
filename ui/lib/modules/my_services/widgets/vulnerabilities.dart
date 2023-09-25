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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../data/security_repository.dart';

class VulnerabilityWidget extends ConsumerStatefulWidget {
  final Service service;

  const VulnerabilityWidget({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<VulnerabilityWidget> createState() => _VulnerabilityWidgetState();
}

class _VulnerabilityWidgetState extends ConsumerState<VulnerabilityWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildVulnerabilitiesSection();
  }

  buildVulnerabilitiesSection() {

    var containerVulnerabilities = ref.watch(containerVulnerabilitiesProvider(
        projectId: widget.service.projectId,
        serviceId: widget.service.serviceId));

    return containerVulnerabilities.when(
        loading: () => LinearProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (vulnerabilities) {
      var vulnerabilitiesMap = {};

      vulnerabilities.forEach((vuln) {
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
                "${widget.service.serviceId}@${name}",
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
    });
  }
}
