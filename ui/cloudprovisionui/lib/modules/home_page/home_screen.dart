import 'package:cloudprovision/app_appbar.dart';
import 'package:cloudprovision/app_drawer.dart';
import 'package:cloudprovision/modules/home_page/home_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: HomeBody(),
    );
  }
}
