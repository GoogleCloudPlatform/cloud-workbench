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
                _menuItem('Microservice Templates',
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
