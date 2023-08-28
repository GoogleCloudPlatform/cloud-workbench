import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';

import 'catalog_entry_card.dart';

import '../data/template_repository.dart';

enum Category {
  application(name: "Application", code: "application"),
  infra(name: "Infra", code: "infra"),
  solution(name: "Solution", code: "solution");

  const Category({required this.name, required this.code});

  final String name;
  final String code;
}

class CatalogList extends ConsumerStatefulWidget {
  bool showDrafts = false;
  List<String> categories = [];
  CatalogList({super.key, required this.categories, required this.showDrafts});

  @override
  ConsumerState<CatalogList> createState() => _CatalogList();
}

class _CatalogList extends ConsumerState<CatalogList> {

  void switchCallback(bool adding, String param) {
    setState(() {
      if (adding == true)
        widget.categories.add(param);
      else
        widget.categories = widget.categories.where((element) => element != param).toList();
    });
  }

  void switchDraftCallback(bool drafts, String param) {
    setState(() {
      widget.showDrafts = drafts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final templatesList = ref.watch(templatesProvider);

    return templatesList.when(
        loading: () => Text('Loading...'),
        error: (err, stack) => Text('Error: $err'),
        data: (listOfTemplates) {
          List<Template> templates = [];

          if (widget.showDrafts) {
            templates = listOfTemplates
                .where((template) => widget.categories.contains(template.category))
                .toList();
          } else {
            templates = listOfTemplates
                .where((template) => widget.categories.contains(template.category) && template.draft == widget.showDrafts)
                .toList();
          }

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
                  Row(
                    children: [
                      CatalogSwitch(
                        Category.application.name,
                        Category.application.code,
                        switchCallback,
                            widget.categories.contains(Category.application.code),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CatalogSwitch(
                          Category.infra.name, Category.infra.code, switchCallback,
                              widget.categories.contains(Category.infra.code)),
                      SizedBox(
                        width: 5,
                      ),
                      CatalogSwitch(
                          Category.solution.name, Category.solution.code, switchCallback,
                              widget.categories.contains(Category.solution.code)),
                      SizedBox(
                        width: 5,
                      ),
                      CatalogSwitch("Drafts", "draft", switchDraftCallback,
                          widget.showDrafts),
                    ],
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

class CatalogSwitch extends StatelessWidget {
  final String switchName;
  final String switchCode;
  final bool isSelected;
  final Function onSwitchUpdate;

   CatalogSwitch(this.switchName, this.switchCode,
       this.onSwitchUpdate, this.isSelected, {super.key });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: Colors.blue[50],
      selectedColor: Colors.blue[100],
      label: Text(switchName),
      selected: isSelected,
      onSelected: (value) {
        onSwitchUpdate(value, switchCode);
      },
    );
  }
}
