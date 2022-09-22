import 'package:cloudprovision/models/template_model.dart';
import 'package:cloudprovision/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'template_config.dart';

class TemplateList extends StatelessWidget {
  final List<TemplateModel> _templates;

  TemplateList(this._templates);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _templates.length,
      itemBuilder: (context, int index) {
        return buildTemplate(_templates[index], context);
      },
    );
  }

  Widget buildTemplate(TemplateModel template, BuildContext context) {
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
              const Text(
                "Template: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
              Text(
                template.name,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Description: ", style: AppText.fontWeightBold),
              Text(template.description),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  final Uri _url = Uri.parse(template.sourceUrl);
                  if (!await launchUrl(_url)) {
                    throw 'Could not launch $_url';
                  }
                },
                child: Image.network(
                    width: 50,
                    'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                  child: const Text('Deploy'),
                  onPressed: () => _deployTemplate(template, context),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _deployTemplate(TemplateModel template, BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TemplateConfigPage(template)));
  }
}
