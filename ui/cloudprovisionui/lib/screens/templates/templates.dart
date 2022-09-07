import 'package:cloudprovision/data/repositories/template_repository.dart';
import 'package:cloudprovision/models/template_model.dart';
import 'package:cloudprovision/screens/templates/template_list.dart';
import 'package:flutter/material.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  List<TemplateModel> _templates = [];
  final _templateRepository = TemplateRepository();

  @override
  Widget build(BuildContext context) {
    // TODO switch to Stream/FutureBuilder pattern
    if (_templates.isEmpty) {
      _templateRepository.loadTemplates(context).then((templates) {
        setState(() {
          _templates = templates;
        });
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: TemplateList(_templates)),
      ],
    );
  }
}
