import 'package:cloudprovision/app_appbar.dart';
import 'package:cloudprovision/app_drawer.dart';
import 'package:flutter/material.dart';

import 'my_services.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: Container(
        child: MyServicesPage(),
      ),
    );
  }
}
