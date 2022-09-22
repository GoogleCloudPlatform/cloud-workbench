part of 'template-bloc.dart';

abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

class TemplateInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplateLoaded extends TemplateState {
  final TemplateModel template;
  const TemplateLoaded(this.template);
}

class TemplateError extends TemplateState {
  final String? message;
  const TemplateError(this.message);
}
