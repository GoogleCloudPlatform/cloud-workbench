import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../app_appbar.dart';
import '../../app_drawer.dart';

class ExampleScreen extends StatelessWidget {
  TextStyle textStyle = GoogleFonts.openSans(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8);

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: App_AppBar(),
      drawer: AppDrawer(),
      body: Text("Example"),
    );
  }
}
