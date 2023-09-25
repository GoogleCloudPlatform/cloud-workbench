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

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:cloudprovision/widgets/cloud_card.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../../my_services/my_services.dart';
import 'deploy_dialog.dart';

class CatalogEntryCard extends StatelessWidget {
  final Template entry;
  CatalogEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final serviceIcon = getServiceIcon(entry);
    return InkWell(
      onTap: () {
        _dialogBuilder(context, entry);
      },
      child: CloudCard(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage('assets/images/${serviceIcon}.png'),
                height: 40,
              ),
              SizedBox(height: 10),
              Text(
                entry.name,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 5),
              Text(entry.description),
              SizedBox(height: 5),
              Text("Category: ${entry.category}"),
              SizedBox(height: 5),
              entry.draft == true
                  ? Text("(Draft)", style: Theme.of(context).textTheme.bodyLarge,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Template template) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CatalogEntryDeployDialog(template, "application");
      },
    );
  }

  getServiceIcon(Template template) {
    String val =
        template.tags.toString().toLowerCase() + template.name.toLowerCase();

    return getIconImage(val);
  }
}
