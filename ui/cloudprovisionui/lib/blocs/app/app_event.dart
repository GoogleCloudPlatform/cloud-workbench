part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetAppState extends AppEvent {}

class GetMyServices extends AppEvent {}

class SettingsChanged extends AppEvent {
  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;

  SettingsChanged(this.templateGitRepository, this.instanceGitUsername,
      this.instanceGitToken);

  @override
  List<Object> get props =>
      [templateGitRepository, instanceGitUsername, instanceGitToken];

  @override
  String toString() {
    return 'SettingsChangedEvent{templateGitRepository: $templateGitRepository, instanceGitUsername: $instanceGitUsername, instanceGitToken: $instanceGitToken}';
  }
}

class CastSettingsChanged extends AppEvent {
  final String castAPI;
  final String castAccessToken;

  CastSettingsChanged(this.castAPI, this.castAccessToken);

  @override
  List<Object> get props => [castAPI, castAccessToken];
}

class LoadCastAssessment extends AppEvent {
  final int campaignId;
  final String castAccessToken;

  LoadCastAssessment(this.campaignId, this.castAccessToken);

  @override
  List<Object> get props => [campaignId, castAccessToken];
}

class ServiceDeploymentRequest extends AppEvent {
  final String name;
  final String owner;
  final String instanceRepo;
  final String templateName;
  final int templateId;
  final String region;
  final String projectId;
  final String cloudBuildId;
  final Map<String, dynamic> params;

  ServiceDeploymentRequest({
    required this.name,
    required this.owner,
    required this.instanceRepo,
    required this.templateId,
    required this.templateName,
    required this.region,
    required this.projectId,
    required this.cloudBuildId,
    required this.params,
  });

  @override
  List<Object> get props => [
        name,
        owner,
        instanceRepo,
        templateId,
        templateName,
        region,
        projectId,
        cloudBuildId,
        params
      ];
}
