part of 'template-bloc.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

class TemplateInitial extends TemplateState {}

class TemplatesInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplatesLoading extends TemplateState {}

class TemplateLoaded extends TemplateState {
  final Template template;
  const TemplateLoaded(this.template);
}

class TemplatesLoaded extends TemplateState {
  final List<Template> templates;
  const TemplatesLoaded(this.templates);
}

class TemplateError extends TemplateState {
  final String? message;
  const TemplateError(this.message);
}
