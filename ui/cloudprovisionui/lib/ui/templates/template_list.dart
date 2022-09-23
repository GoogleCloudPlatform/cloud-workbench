import 'package:cloudprovision/blocs/template/template-bloc.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'template_config.dart';

class TemplateList extends StatelessWidget {
  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        child: CircularProgressIndicator(),
        height: 10.0,
        width: 10.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemplateBloc, TemplateState>(builder: (context, state) {
      if (state is TemplatesInitial) {
        return _buildLoading();
      } else if (state is TemplatesLoading) {
        return _buildLoading();
      } else if (state is TemplatesLoaded) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: state.templates.length,
          itemBuilder: (context, int index) {
            return buildTemplate(state.templates[index], context);
          },
        );
      } else if (state is TemplateError) {
        return Container();
      } else {
        return Container();
      }
    });
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

  _deployTemplate(Template template, BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TemplateConfigPage(template)));
  }
}