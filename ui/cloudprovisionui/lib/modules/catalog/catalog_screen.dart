import 'package:cloudprovision/app_appbar.dart';
import 'package:cloudprovision/app_drawer.dart';

import 'package:flutter/material.dart';

import 'widgets/catalog_list.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: Container(
        child: CatalogList(category: "application", catalogSource: "gcp"),
      ),
    );
  }
}
