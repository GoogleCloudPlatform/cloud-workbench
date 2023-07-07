import 'package:cloudprovision/app_appbar.dart';
import 'package:cloudprovision/app_drawer.dart';
import 'package:flutter/material.dart';

import 'my_workstations.dart';

class MyWorkstationsScreen extends StatelessWidget {
  const MyWorkstationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: Container(
        child: MyWorkstationsPage(),
      ),
    );
  }
}
