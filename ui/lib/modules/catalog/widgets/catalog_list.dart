import 'package:cloudprovision/widgets/cloud_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';

import 'catalog_entry_card.dart';
import 'deploy_dialog.dart';

import '../data/template_repository.dart';

class CatalogList extends ConsumerWidget {
  final String category;
  final String catalogSource;
  CatalogList({super.key, required this.category, required this.catalogSource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesList = ref.watch(templatesProvider(catalogSource, category));

    return templatesList.when(
        loading: () => Text('Loading...'),
        error: (err, stack) => Text('Error: $err'),
        data: (templates) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cloud Provision Catalog",
                    style: GoogleFonts.openSans(
                      fontSize: 32,
                      color: Color(0xFF1b3a57),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(),
                  Text(
                    templates.isEmpty ? "No entries found" : "",
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Color(0xFF1b3a57),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  templates.isNotEmpty
                      ? _templates(context, templates)
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  _templates(BuildContext context, List<Template> templates) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CatalogEntryCard(entry: templates[index]);
            },
            itemCount: templates.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
            ),
          )
        ],
      ),
    );
  }
}
