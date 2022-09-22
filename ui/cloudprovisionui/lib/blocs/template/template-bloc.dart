import 'package:bloc/bloc.dart';
import 'package:cloudprovision/data/repositories/template_repository.dart';
import 'package:cloudprovision/models/template_model.dart';
import 'package:equatable/equatable.dart';
part 'template-event.dart';
part 'template-state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  TemplateBloc() : super(TemplateInitial()) {
    final TemplateRepository _templateRepository = TemplateRepository();

    on<GetTemplate>((event, emit) async {
      try {
        emit(TemplateLoading());
        final template =
            await _templateRepository.loadTemplateById(event.template.id);
        emit(TemplateLoaded(template));
      } on Exception {
        emit(const TemplateError("Failed to fetch template details."));
      }
    });
  }
}
