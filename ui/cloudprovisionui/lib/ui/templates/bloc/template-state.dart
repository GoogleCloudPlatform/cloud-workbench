part of 'template-bloc.dart';

class TemplateState extends Equatable {
  const TemplateState({templates, selectedTags})
      : templates = templates ?? const <Template>[],
        selectedTags = selectedTags ?? const <String>[];

  final List<Template> templates;
  final List<String> selectedTags;

  TemplateState copyWith({
    List<Template>? templates,
    List<String>? selectedTags,
  }) {
    return TemplateState(
        templates: templates ?? this.templates,
        selectedTags: selectedTags ?? this.selectedTags);
  }

  @override
  List<Object?> get props => [templates, selectedTags];
}

class TemplateInitial extends TemplateState {}

class TemplatesInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplatesLoading extends TemplateState {}

class TemplatesListFiltered extends TemplateState {
  final List<String> selectedTags;
  final List<Template> templates;
  const TemplatesListFiltered(this.templates, this.selectedTags);
}

class TemplateLoaded extends TemplateState {
  final Template template;
  const TemplateLoaded(this.template);
}

class TemplatesLoaded extends TemplateState {
  final List<Template> templates;
  const TemplatesLoaded(this.templates);
}

class TemplateGitConfigUpdated extends TemplateState {
  final String sourceRepo;
  final String targetRepoName;
  final String token;

  TemplateGitConfigUpdated(this.sourceRepo, this.targetRepoName, this.token);
}

class TemplateError extends TemplateState {
  final String? message;
  const TemplateError(this.message);
}
