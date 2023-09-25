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
