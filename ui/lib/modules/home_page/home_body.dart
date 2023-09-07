import 'package:flutter/material.dart';

import 'item_card_layout_grid.dart';

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
  String dest;

  SectionItem(
      {required this.title,
      required this.subTitle,
      required this.image,
      required this.dest});
}

final Section dashboardSection = Section(
    title: "Main Dashboard\n",
    subTitle: "Create and manage your applications",
    items: [
      SectionItem(
        title: "My Services",
        subTitle: "Manage existing services",
        image: "experiments",
        dest: "/services",
      ),
      SectionItem(
        title: "My Workstations",
        subTitle: "Manage available Cloud Workstations",
        image: "disovery_card_ml2",
        dest: "/workstations",
      ),
      SectionItem(
        title: "App Catalog",
        subTitle: "Create a new application from a template",
        image: "appdistro@2x",
        dest: "/catalog",
      ),
    ]);

final Section cloudProvisionCatalogSection = Section(
    title: "Cloud Provision Catalog",
    subTitle: "Create and deploy a new service from available templates",
    items: [
      SectionItem(
        title: "Application Templates",
        subTitle: "Create a new application from a template",
        image: "appdistro@2x",
        dest: "/catalog",
      ),
    ]);

final Section teamsSection = Section(
    title: "Teams",
    subTitle: "Create a new team and onboard developers",
    items: [
      SectionItem(
        title: "Setup Team",
        subTitle: "Create a new team",
        image: "analytics",
        dest: "/home",
      ),
      SectionItem(
        title: "Users",
        subTitle: "Add developers",
        image: "discovery-cards-crashlytics",
        dest: "/home",
      ),
      SectionItem(
        title: "Services",
        subTitle: "Configure team's services",
        image: "inappmessaging",
        dest: "/home",
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
        dest: "/home",
      ),
      SectionItem(
        title: "RunBook Docs",
        subTitle: "Review RunBook Docs",
        image: "disovery_card_ml2",
        dest: "/home",
      ),
      SectionItem(
        title: "Developer Docs",
        subTitle: "Review Developer Docs",
        image: "storage",
        dest: "/home",
      ),
      SectionItem(
        title: "Ops Metrics",
        subTitle: "Review Ops Metrics",
        image: "performance",
        dest: "/home",
      )
    ]);

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SelectableText("Welcome to Google Cloud Developer Workbench",
            //     style: Theme.of(context).textTheme.titleLarge),

            // Divider(),
            // SelectableText("Accelerating development on Google Cloud",
            //     style: Theme.of(context).textTheme.titleSmall),

            _cloudProvisionCatalog(dashboardSection, context),
            // _cloudProvisionCatalog(cloudProvisionCatalogSection, context),
            // _cloudProvisionCatalog(teamsSection, context),
            // _cloudProvisionCatalog(servicesSection, context),
          ],
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
                child: SelectableText(section.title,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                constraints: BoxConstraints(minWidth: 500, maxWidth: 910),
                width: MediaQuery.of(context).size.width,
                child: SelectableText(section.subTitle,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ItemCardLayoutGrid(
                    crossAxisCount: 3,
                    items: section.items,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
