import 'package:cloudprovision/repository/models/metadata_model.dart';
import 'package:cloudprovision/ui/main/main_screen.dart';
import 'package:cloudprovision/ui/templates/bloc/template-bloc.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/ui/templates/tags_filter.dart';
import 'package:cloudprovision/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'template_config.dart';

class TemplateList extends StatefulWidget {
  final void Function(NavigationPage page) navigateTo;
  final String category;
  final String catalogSource;
  TemplateList(this.category, this.navigateTo, this.catalogSource);

  @override
  State<TemplateList> createState() => _TemplateListState();
}

class _TemplateListState extends State<TemplateList> {
  List<Template> filteredList = [];

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 10.0,
          width: 10.0,
        ),
      ),
    );
  }

  _addedTag(String tag) {
    List<Template> list =
        filteredList.where((template) => template.tags.contains(tag)).toList();

    setState(() {
      filteredList = list;
    });

    BlocProvider.of<TemplateBloc>(context).add(TemplatesListTagAdded(tag));
  }

  _removedTag(String tag) {
    BlocProvider.of<TemplateBloc>(context).add(TemplatesListTagRemoved(tag));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          BlocBuilder<TemplateBloc, TemplateState>(builder: (context, state) {
        if (state is TemplatesInitial) {
          return _buildLoading();
        } else if (state is TemplatesLoading) {
          return _buildLoading();
        } else if (state is TemplatesListFiltered) {
          if (state.selectedTags.isEmpty) {
            if (widget.category == "all") {
              filteredList = state.templates;
            } else {
              filteredList = state.templates
                  .where((template) => template.category == widget.category)
                  .toList();
            }
          } else {
            if (widget.category == "all") {
              filteredList = state.templates.where((template) {
                return template.tags
                    .toSet()
                    .containsAll(state.selectedTags.toSet());
              }).toList();
            } else {
              filteredList = state.templates.where((template) {
                return template.category == widget.category &&
                    template.tags
                        .toSet()
                        .containsAll(state.selectedTags.toSet());
              }).toList();
            }
          }

          Map<String, dynamic> tags = {};

          for (Template template in filteredList) {
            template.tags.forEach((tag) {
              tags[tag] = null;
            });
          }

          return _buildList(tags.keys.toList());
        } else if (state is TemplatesLoaded) {
          if (widget.category == "all") {
            filteredList = state.templates;
          } else {
            filteredList = state.templates
                .where((template) => template.category == widget.category)
                .toList();
          }

          Map<String, dynamic> tags = {};

          for (Template template in filteredList) {
            template.tags.forEach((tag) {
              tags[tag] = null;
            });
          }

          return _buildList(tags.keys.toList());
        } else if (state is TemplateError) {
          return Container();
        } else {
          return Container();
        }
      }),
    );
  }

  _buildList(List<String> tags) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 500,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "Filter:",
                    style: AppText.fontStyleBold,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TagsFilterWidget(tags, _addedTag, _removedTag),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, int index) {
                return buildTemplate(filteredList[index], context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTemplate(Template template, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: [
              Text(
                "Template: ",
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                template.name,
                style: GoogleFonts.openSans(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Description: ", style: AppText.fontStyleBold),
              Text(
                template.description,
                style: AppText.fontStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Owner: ", style: AppText.fontStyleBold),
              TextButton(
                onPressed: () async {
                  final Uri _url = Uri.parse(
                      "http://mail.google.com/mail/?view=cm&fs=1&tf=1&to=${template.email}&su=Feedback: ${template.name}&body=Hello ${template.owner},\nI would like to provide feedback for template: ${template.name}\nVersion: ${template.version}\nGit: ${template.sourceUrl}\n\n\n");
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch $_url';
                  }
                },
                child: Text(
                  template.owner,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppText.linkFontStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Template Repo: ", style: AppText.fontStyleBold),
              TextButton(
                onPressed: () async {
                  final Uri _url = Uri.parse(template.sourceUrl);
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch $_url';
                  }
                },
                child: Text(
                  template.sourceUrl,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppText.linkFontStyle,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Version: ", style: AppText.fontStyleBold),
              Text(
                template.version,
                style: AppText.fontStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Last Modified: ", style: AppText.fontStyleBold),
              Text(
                DateFormat('MM/d/yy, h:mm a').format(template.lastModified),
                style: AppText.fontStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Tags: ", style: AppText.fontStyleBold),
              for (String tag in template.tags)
                Row(
                  children: [
                    Chip(
                      elevation: 5,
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        tag,
                        style: AppText.buttonFontStyle,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Resources (ref guides, codelabs, etc): ",
                  style: AppText.fontStyleBold),
            ],
          ),
          const SizedBox(height: 5),
          for (TemplateMetadata tm in template.metadata)
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final Uri _url = Uri.parse(tm.value);
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Text(
                    tm.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppText.linkFontStyle,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Deploy',
                    style: AppText.buttonFontStyle,
                  ),
                  onPressed: () => _deployTemplate(template, context),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _deployTemplate(Template template, BuildContext parentContext) async {
    Navigator.push(
      parentContext,
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider.value(
            value: BlocProvider.of<TemplateBloc>(parentContext),
            child: TemplateConfigPage(
                template, widget.navigateTo, widget.catalogSource),
          );
        },
      ),
    );
  }
}
