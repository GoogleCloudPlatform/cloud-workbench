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
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });
  _subTitle(String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(subTitle),
    );
  }

  _menuItem(
    String menuItemText,
    String dest,
    BuildContext context, {
    IconData iconData = Icons.miscellaneous_services,
    bool settings = false,
    bool notification = false,
  }) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 10),
            Text(menuItemText, style: Theme.of(context).textTheme.bodyMedium),
            settings
                ? Row(
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        icon: new Icon(Icons.settings),
                        onPressed: () => context.go('/settings'),
                      ),
                    ],
                  )
                : Container(),
            notification
                ? Row(
                    children: [
                      SizedBox(width: 70),
                      Chip(
                        padding: EdgeInsets.all(0),
                        backgroundColor: Colors.red,
                        label: Text('5', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      dense: true,
      onTap: () {
        context.go('/' + dest);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SizedBox(
              height: 64,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Developer Workbench',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                _menuItem("Workspace Overview", "home", context,
                    iconData: Icons.home, settings: true),
                _menuItem("Settings", "settings", context),
                Divider(),
                _subTitle("Dashboard"),
                _menuItem("My Services", "services", context,
                    iconData: Icons.format_list_bulleted_outlined),
                Divider(),
                _subTitle("Cloud Provision Catalog"),
                _menuItem('Application Templates',
                    "catalog?filter=application", context,
                    iconData: Icons.list_sharp),
                _menuItem('Infra Templates', "catalog?filter=infra", context,
                    iconData: Icons.list_sharp),
                _menuItem(
                    'Solutions Templates', "catalog?filter=solution", context,
                    iconData: Icons.list_sharp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
