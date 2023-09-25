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

import 'package:cloudprovision/app_appbar.dart';
import 'package:cloudprovision/app_drawer.dart';

import 'package:flutter/material.dart';

import 'widgets/catalog_list.dart';

class CatalogScreen extends StatelessWidget {
  final Map<String, String> queryParams;

  const CatalogScreen({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context) {

    List<String> filterValues = [];

    if (queryParams.containsKey("filter")) {
      filterValues = queryParams["filter"]!.split(",").toList();
    } else {
      filterValues.addAll(["application", "infra", "solution"]);
    }

    bool showDrafts = false;

    if (queryParams.containsKey("drafts")) {
      showDrafts = queryParams["drafts"]?.toLowerCase() == 'true';
    }

    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: Container(
        child: CatalogList(categories: filterValues, showDrafts: showDrafts),
      ),
    );
  }
}
