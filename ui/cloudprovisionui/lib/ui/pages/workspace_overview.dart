import 'package:cloudprovision/ui/main/main_screen.dart';
import 'package:cloudprovision/ui/pages/item_card_layout_grid.dart';
import 'package:cloudprovision/ui/templates/bloc/template-bloc.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Section {
  String title;
  String subTitle;
  List<SectionItem> items;

  Section({required this.title, required this.subTitle, required this.items});
}

class SectionItem {
  String title;
  String subTitle;
  String image;
  NavigationPage page;

  SectionItem(
      {required this.title,
      required this.subTitle,
      required this.image,
      required this.page});
}

final Section dashboardSection = Section(
    title: "Workspace Dashboard",
    subTitle: "Manage your services",
    items: [
      SectionItem(
        title: "My Services",
        subTitle: "Review created services",
        image: "experiments",
        page: NavigationPage.MyServices,
      ),
      SectionItem(
        title: "Notifications",
        subTitle: "Review workspace notifications",
        image: "cloudmessaging",
        page: NavigationPage.Notifications,
      ),
      SectionItem(
        title: "Settings",
        subTitle: "Workspace settings",
        image: "hosting",
        page: NavigationPage.Settings,
      ),
    ]);

final Section cloudProvisionCatalogSection = Section(
    title: "Cloud Provision Catalog",
    subTitle: "Create and deploy a new service from available templates",
    items: [
      SectionItem(
        title: "Microservice Templates",
        subTitle: "Create a new service from the Cloud Provision Catalog",
        image: "appdistro@2x",
        page: NavigationPage.MicroserviceTemplates,
      ),
      SectionItem(
        title: "Solution Architectures",
        subTitle: "Create a new service from the Cloud Provision Catalog",
        image: "functions",
        page: NavigationPage.SolutionArchitectures,
      ),
      SectionItem(
        title: "Infra Modules",
        subTitle: "Create a new service from the Cloud Provision Catalog",
        image: "realtime_database2x",
        page: NavigationPage.InfraModules,
      ),
      SectionItem(
        title: "Stack Composer",
        subTitle: "Create a new service from the Cloud Provision Catalog",
        image: "dynamiclinks",
        page: NavigationPage.StackComposer,
      )
    ]);

final Section teamsSection = Section(
    title: "Teams",
    subTitle: "Create a new team and onboard developers",
    items: [
      SectionItem(
        title: "Setup Team",
        subTitle: "Create a new team",
        image: "analytics",
        page: NavigationPage.TeamSetup,
      ),
      SectionItem(
        title: "Users",
        subTitle: "Add developers",
        image: "discovery-cards-crashlytics",
        page: NavigationPage.TeamUsers,
      ),
      SectionItem(
        title: "Services",
        subTitle: "Configure team's services",
        image: "inappmessaging",
        page: NavigationPage.TeamServices,
      ),
    ]);

final Section servicesSection = Section(
    title: "Service Management",
    subTitle: "Manage your services",
    items: [
      SectionItem(
        title: "Score Card Ratings",
        subTitle: "View Score Card Ratings",
        image: "app_check_discovery_card@2x",
        page: NavigationPage.ScoreCardRating,
      ),
      SectionItem(
        title: "RunBook Docs",
        subTitle: "Review RunBook Docs",
        image: "disovery_card_ml2",
        page: NavigationPage.RunBookDocs,
      ),
      SectionItem(
        title: "Developer Docs",
        subTitle: "Review Developer Docs",
        image: "storage",
        page: NavigationPage.DeveloperDocs,
      ),
      SectionItem(
        title: "Ops Metrics",
        subTitle: "Review Ops Metrics",
        image: "performance",
        page: NavigationPage.OpsMetrics,
      )
    ]);

class WorkspaceOverviewPage extends StatelessWidget {
  final void Function(NavigationPage page) navigateTo;

  WorkspaceOverviewPage({required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TemplateRepository(service: TemplateService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TemplateBloc>(
            create: (context) => TemplateBloc(
              templateRepository: context.read<TemplateRepository>(),
            )..add(GetTemplatesList()),
          ),
        ],
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  "Welcome to Google Cloud Developer Workbench",
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                SelectableText(
                  "Accelerating development on Google Cloud",
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _cloudProvisionCatalog(dashboardSection, context),
                _cloudProvisionCatalog(cloudProvisionCatalogSection, context),
                _cloudProvisionCatalog(teamsSection, context),
                _cloudProvisionCatalog(servicesSection, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cloudProvisionCatalog(Section section, BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(minWidth: 500, maxWidth: 1100),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50.0),
                constraints: BoxConstraints(minWidth: 500, maxWidth: 910),
                width: MediaQuery.of(context).size.width,
                child: SelectableText(
                  section.title,
                  style: GoogleFonts.openSans(
                    fontSize: 26,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                constraints: BoxConstraints(minWidth: 500, maxWidth: 910),
                width: MediaQuery.of(context).size.width,
                child: SelectableText(
                  section.subTitle,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ItemCardLayoutGrid(
                      crossAxisCount: 3,
                      items: section.items,
                      navigateTo: navigateTo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
