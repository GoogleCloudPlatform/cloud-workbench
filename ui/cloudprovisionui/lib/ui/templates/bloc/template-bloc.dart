import 'dart:async';

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
    on<TemplatesListTagAdded>(_mapTemplatesListTagAddedToState);
    on<TemplatesListTagRemoved>(_mapTemplatesListTagRemovedToState);
  }

  void _mapTemplatesListTagAddedToState(
      TemplatesListTagAdded event, Emitter<TemplateState> emit) async {
    List<String> updatedList = new List<String>.from(state.selectedTags)
      ..add(event.tag);

    emit(TemplatesListFiltered(state.templates, updatedList));
  }

  void _mapTemplatesListTagRemovedToState(
      TemplatesListTagRemoved event, Emitter<TemplateState> emit) async {
    List<String> updatedList = [];

    if (event.tag == "*") {
      // clear all tags
    } else {
      updatedList = new List<String>.from(state.selectedTags)
        ..remove(event.tag);
    }
    emit(TemplatesListFiltered(state.templates, updatedList));
  }

  void _mapGetTemplateToState(
      GetTemplate event, Emitter<TemplateState> emit) async {
    try {
      emit(TemplateLoading());

      String catalogSource = "gcp";

      if (event.template.sourceUrl.contains("community")) {
        catalogSource = "community";
      }

      final template = await templateRepository.loadTemplateById(
          event.template.id, catalogSource);

      emit(TemplateLoaded(template));
    } on Exception {
      emit(const TemplateError("Failed to fetch template details."));
    }
  }

  void _mapGetTemplatesListToState(
      GetTemplatesList event, Emitter<TemplateState> emit) async {
    try {
      emit(TemplatesLoading());
      final templates = await templateRepository.loadTemplates(
          event.catalogSource, event.catalogUrl);
      emit(TemplatesLoaded(templates));
    } on Exception {
      emit(const TemplateError("Failed to fetch list of templates."));
    }
  }
}
