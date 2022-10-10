part of 'template-bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object> get props => [];
}

class GetTemplatesList extends TemplateEvent {
  final String catalogSource;
  final String catalogUrl;

  GetTemplatesList({required this.catalogSource, required this.catalogUrl});
}

class GetTemplate extends TemplateEvent {
  GetTemplate({required this.template});

  final Template template;
}

class TemplatesListTagAdded extends TemplateEvent {
  TemplatesListTagAdded(this.tag);

  final String tag;
}

class TemplatesListTagRemoved extends TemplateEvent {
  TemplatesListTagRemoved(this.tag);

  final String tag;
}

class ForkTemplateRepo extends TemplateEvent {
  final String sourceRepo;
  final String targetRepoName;
  final String token;

  ForkTemplateRepo(this.sourceRepo, this.targetRepoName, this.token);
}
