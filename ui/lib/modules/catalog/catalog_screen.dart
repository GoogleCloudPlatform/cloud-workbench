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
