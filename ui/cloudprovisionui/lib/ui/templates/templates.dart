import 'package:cloudprovision/blocs/template/template-bloc.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:cloudprovision/ui/templates/template_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TemplateRepository(service: TemplateService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TemplateBloc>(
            create: (context) => TemplateBloc(
              templateRepository: context.read<TemplateRepository>(),
            )..add(GetTemplatesList()),
          ),
        ],
        child: TemplateList(),
      ),
    );
  }
}
