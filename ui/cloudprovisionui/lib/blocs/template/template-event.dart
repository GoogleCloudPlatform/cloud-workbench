part of 'template-bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object> get props => [];
}

class GetTemplatesList extends TemplateEvent {}

class GetTemplate extends TemplateEvent {
  GetTemplate({required this.template});

  final Template template;
}
