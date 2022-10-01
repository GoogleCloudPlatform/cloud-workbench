part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetAppState extends AppEvent {}

class SettingsChangedEvent extends AppEvent {
  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;

  SettingsChangedEvent(this.templateGitRepository, this.instanceGitUsername,
      this.instanceGitToken);

  @override
  List<Object> get props =>
      [templateGitRepository, instanceGitUsername, instanceGitToken];

  @override
  String toString() {
    return 'SettingsChangedEvent{templateGitRepository: $templateGitRepository, instanceGitUsername: $instanceGitUsername, instanceGitToken: $instanceGitToken}';
  }
}

class ServiceDeployedEvent extends AppEvent {
  final String name;
  final String owner;
  final String instanceRepo;
  final String templateName;
  final String region;
  final String projectId;

  ServiceDeployedEvent(this.name, this.owner, this.instanceRepo,
      this.templateName, this.region, this.projectId);

  @override
  List<Object> get props =>
      [name, owner, instanceRepo, templateName, region, projectId];
}
