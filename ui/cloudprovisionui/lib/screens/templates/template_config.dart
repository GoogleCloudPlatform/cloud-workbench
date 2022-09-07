import 'package:cloudprovision/data/repositories/template_repository.dart';
import 'package:cloudprovision/models/param_model.dart';
import 'package:cloudprovision/models/template_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloudprovision/data/repositories/build_repository.dart';

class TemplateConfigPage extends StatefulWidget {
  final TemplateModel _template;
  TemplateConfigPage(this._template, {super.key});

  @override
  State<TemplateConfigPage> createState() =>
      _TemplateConfigPageState(_template);
}

class _TemplateConfigPageState extends State<TemplateConfigPage> {
  late TemplateModel _template;
  final _templateRepository = TemplateRepository();

  _TemplateConfigPageState(this._template);

  @override
  Widget build(BuildContext context) {
    // TODO switch to Stream/FutureBuilder pattern
    // if (_templates.isEmpty) {
    //   _templateRepository.loadTemplates(context).then((templates) {
    //     setState(() {
    //       _templates = templates;
    //     });
    //   });
    // }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  const Text("Template: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_template.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ],
              ),
              Row(
                children: [
                  const Text("Description: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      )),
                  Text(_template.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final Uri _url = Uri.parse(_template.sourceUrl);
                      if (!await launchUrl(_url)) {
                        throw 'Could not launch $_url';
                      }
                    },
                    child: Image.network(
                        width: 50,
                        'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
                  ),
                ],
              ),
              _params(context),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: ElevatedButton(
                  child: const Text('Deploy template'),
                  onPressed: () => _deployTemplate(_template, context),
                ),
              ),
            ],
          ),
        ),
      ],
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

  _params(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _template.params.length,
        itemBuilder: (context, index) {
          return _row(index, _template.params[index]);
        },
      ),
    );
  }

  _row(int index, ParamModel param) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(param.label),
        SizedBox(width: 30),
        SizedBox(
          width: 200.0,
          child: TextFormField(),
        ),
      ],
    );
  }
}
