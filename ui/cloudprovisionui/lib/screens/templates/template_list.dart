import 'package:cloudprovision/data/repositories/build_repository.dart';
import 'package:cloudprovision/models/template_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              const Text("Template: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(template.name),
            ],
          ),
          Row(
            children: [
              const Text("Description: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(template.name),
            ],
          ),
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
    String? buildDetails = await BuildRepository().deployTemplate(template);

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            SelectableText(
              buildDetails!,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Template deployed'),
      ),
    );
  }
}
