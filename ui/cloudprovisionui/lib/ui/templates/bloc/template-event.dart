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

class ForkTemplateRepo extends TemplateEvent {
  final String sourceRepo;
  final String targetRepoName;
  final String token;

  ForkTemplateRepo(this.sourceRepo, this.targetRepoName, this.token);
}
