import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main/main_screen.dart';
import 'bloc/template-bloc.dart';
import '../../repository/service/template_service.dart';
import '../../repository/template_repository.dart';
import 'template_list.dart';

class TemplatesPage extends StatelessWidget {
  final void Function(NavigationPage page) navigateTo;
  final String category;
  final String catalogSource;

  const TemplatesPage({
    super.key,
    required this.navigateTo,
    required this.category,
    this.catalogSource = "gcp",
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TemplateRepository(service: TemplateService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TemplateBloc>(
            create: (context) => TemplateBloc(
              templateRepository: context.read<TemplateRepository>(),
            )..add(GetTemplatesList(
                catalogSource: this.catalogSource, catalogUrl: "")),
          ),
        ],
        child: TemplateList(category, navigateTo, this.catalogSource),
      ),
    );
  }
}