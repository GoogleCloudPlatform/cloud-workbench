import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../screens/integrations/cast_highlight.dart';
import '../../screens/my_services/my_services.dart';
import '../../screens/pages/page.dart';
import '../../screens/pages/workspace_overview.dart';
import '../../screens/settings/settings.dart';
import '../../screens/signin/sign_in.dart';
import '../../screens/templates/templates.dart';
import '../../utils/styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

enum NavigationPage {
  Settings,
  WorkspaceOverview,
  MyServices,
  Notifications,
  MicroserviceTemplates,
  SolutionArchitectures,
  InfraModules,
  CommunityTemplates,
  CustomerTemplates,
  StackComposer,
  TeamSetup,
  TeamUsers,
  TeamServices,
  ScoreCardRating,
  RunBookDocs,
  DeveloperDocs,
  OpsMetrics,
  CastHighlight,
}

enum SolutionCatalogCategory { application, solution, infra, all }

enum SolutionCatalogSource { gcp, community, customer }

class MainScreenState extends State<MainScreen> {
  late Map<NavigationPage, Widget> pages;
  MainScreenState() {
    pages = {
      NavigationPage.WorkspaceOverview:
          WorkspaceOverviewPage(navigateTo: (page) {
        navigateTo(page);
      }),
      NavigationPage.MicroserviceTemplates: TemplatesPage(
          catalogSource: SolutionCatalogSource.gcp.name,
          category: SolutionCatalogCategory.application.name,
          navigateTo: (page) {
            navigateTo(page);
          }),
      NavigationPage.SolutionArchitectures: TemplatesPage(
          catalogSource: SolutionCatalogSource.gcp.name,
          category: SolutionCatalogCategory.solution.name,
          navigateTo: (page) {
            navigateTo(page);
          }),
      NavigationPage.InfraModules: TemplatesPage(
          catalogSource: SolutionCatalogSource.gcp.name,
          category: SolutionCatalogCategory.infra.name,
          navigateTo: (page) {
            navigateTo(page);
          }),
      NavigationPage.CommunityTemplates: TemplatesPage(
          category: SolutionCatalogCategory.all.name,
          catalogSource: SolutionCatalogSource.community.name,
          navigateTo: (page) {
            navigateTo(page);
          }),
      NavigationPage.CustomerTemplates: TemplatesPage(
          category: SolutionCatalogCategory.all.name,
          catalogSource: SolutionCatalogSource.customer.name,
          navigateTo: (page) {
            navigateTo(page);
          }),
      NavigationPage.Settings: SettingsPage(),
      NavigationPage.MyServices: MyServicesPage(),
      NavigationPage.CastHighlight: CastHighlightPage(navigateTo: (page) {
        navigateTo(page);
      }),
    };
  }

  NavigationPage currentPage = NavigationPage.WorkspaceOverview;
  // NavigationPage currentPage = NavigationPage.CastHighlight;

  void navigateTo(NavigationPage page) {
    setState(() {
      if (page == NavigationPage.MyServices) {
        BlocProvider.of<AppBloc>(context).add(GetMyServices());
      }

      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      drawer: Drawer(
        width: 260,
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
                    style: GoogleFonts.openSans(
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
                  _menuItem("Workspace Overview",
                      NavigationPage.WorkspaceOverview, context,
                      iconData: Icons.home, settings: true),
                  Divider(),
                  _subTitle("Dashboard"),
                  _menuItem("My Services", NavigationPage.MyServices, context),
                  Divider(),
                  _subTitle("Cloud Provision Catalog"),
                  _menuItem('Microservice Templates',
                      NavigationPage.MicroserviceTemplates, context),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              currentPage = NavigationPage.WorkspaceOverview;
            });
          },
          child: Text(
            'Developer Workbench',
            style: GoogleFonts.openSans(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                user.displayName != null
                    ? Tooltip(
                        message: "${user.email}",
                        child: Text("${user.displayName}",
                            style: AppText.buttonFontStyle),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey)),
                    child: const Icon(Icons.logout_sharp),
                    onPressed: () {
                      // Signing out the user
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                // Navigate to the sign in screen when the user Signs Out
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: pages.containsKey(currentPage)
            ? pages[currentPage]!
            : SingleChildScrollView(
                child: DefaultPage(
                  title: currentPage.toString(),
                ),
              ),
      ),
    );
  }

  _subTitle(String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(subTitle),
    );
  }

  _menuItem(
    String menuItemText,
    NavigationPage page,
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
            Text(
              menuItemText,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto"),
            ),
            settings
                ? Row(
                    children: [
                      SizedBox(width: 10),
                      IconButton(
                        icon: new Icon(Icons.settings),
                        onPressed: () {
                          setState(() {
                            currentPage = NavigationPage.Settings;
                            Navigator.pop(context);
                          });
                        },
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
        setState(() {
          if (page == NavigationPage.MyServices) {
            BlocProvider.of<AppBloc>(context).add(GetMyServices());
          }

          currentPage = page;
          Navigator.pop(context);
        });
      },
    );
  }
}
