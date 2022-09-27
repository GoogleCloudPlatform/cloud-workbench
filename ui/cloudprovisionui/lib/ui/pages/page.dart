import 'package:cloudprovision/ui/templates/bloc/template-bloc.dart';
import 'package:cloudprovision/repository/service/template_service.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultPage extends StatelessWidget {
  String title;
  DefaultPage({required this.title});

  @override
  Widget build(BuildContext context) {
    title = title.split(".")[1];
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
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 32,
                  color: Color(0xFF1b3a57),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              Text(
                title,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Color(0xFF1b3a57),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
