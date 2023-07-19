import 'package:cloud_provision_shared/catalog/models/template_metadata.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../models/service.dart';

class ServiceResourcesWidget extends StatelessWidget {
  final Service service;
  const ServiceResourcesWidget({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Text(
              'Resources (ref guides, codelabs, etc):',
              style: AppText.fontStyleBold,
            ),
            children: <Widget>[
              for (TemplateMetadata tm in service.template!.metadata)
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final Uri _url = Uri.parse(tm.value);
                        if (!await launchUrl(_url)) {
                          throw 'Could not launch $_url';
                        }
                      },
                      child: Text(
                        tm.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.linkFontStyle,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
