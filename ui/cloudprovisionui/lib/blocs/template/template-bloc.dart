import 'package:bloc/bloc.dart';
import 'package:cloudprovision/repository/template_repository.dart';
import 'package:cloudprovision/repository/models/template.dart';
import 'package:equatable/equatable.dart';
part 'template-event.dart';
part 'template-state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final TemplateRepository templateRepository;

  TemplateBloc({required this.templateRepository}) : super(TemplateInitial()) {
    on<GetTemplate>(_mapGetTemplateToState);
    on<GetTemplatesList>(_mapGetTemplatesListToState);
  }

  void _mapGetTemplateToState(
      GetTemplate event, Emitter<TemplateState> emit) async {
    try {
      emit(TemplateLoading());
      final template =
          await templateRepository.loadTemplateById(event.template.id);
      emit(TemplateLoaded(template));
    } on Exception {
      emit(const TemplateError("Failed to fetch template details."));
    }
  }

  void _mapGetTemplatesListToState(
      GetTemplatesList event, Emitter<TemplateState> emit) async {
    try {
      emit(TemplatesLoading());
      final template = await templateRepository.loadTemplates();
      emit(TemplatesLoaded(template));
    } on Exception {
      emit(const TemplateError("Failed to fetch list of templates."));
    }
  }
}
