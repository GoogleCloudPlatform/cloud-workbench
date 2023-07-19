import 'package:cloudprovision/modules/my_services/models/service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../data/security_repository.dart';
import '../data/security_service.dart';
import '../models/vulnerability.dart';

class VulnerabilityWidget extends StatefulWidget {
  final Service service;

  const VulnerabilityWidget({
    super.key,
    required this.service,
  });

  @override
  State<VulnerabilityWidget> createState() => _VulnerabilityWidgetState();
}

class _VulnerabilityWidgetState extends State<VulnerabilityWidget> {
  bool _loadingVulnerabilities = false;
  List<Vulnerability> _vulnerabilities = [];
  @override
  void initState() {
    _loadingVulnerabilities = true;
    loadVulnerabilities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildVulnerabilitiesSection();
  }

  void loadVulnerabilities() async {
    List<Vulnerability> vulnerabilities =
        await SecurityRepository(service: SecurityService())
            .getContainerVulnerabilities(
      widget.service.projectId,
      widget.service.serviceId,
    );

    setState(() {
      _vulnerabilities = vulnerabilities;
      _loadingVulnerabilities = false;
    });
  }

  buildVulnerabilitiesSection() {
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
  }
}
