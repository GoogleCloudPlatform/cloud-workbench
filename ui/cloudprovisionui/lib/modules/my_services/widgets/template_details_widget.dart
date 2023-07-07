import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../utils/styles.dart';
import '../models/service.dart';

class TemplateDetailsWidget extends StatelessWidget {
  final Service service;
  const TemplateDetailsWidget({
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
              'Template:',
              style: AppText.fontStyleBold,
            ),
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "${service.templateName}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.fontStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${service.template?.version}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.fontStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${service.template?.owner}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.fontStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    DateFormat('MM/d/yy, h:mm a').format(
                        DateTime.parse("${service.template?.lastModified}")),
                    style: AppText.fontStyle,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "(${timeago.format(DateTime.parse("${service.template?.lastModified}"))})",
                    style: AppText.fontStyle,
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
