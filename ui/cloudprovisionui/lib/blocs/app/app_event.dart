part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetAppState extends AppEvent {}

class GetMyServices extends AppEvent {}

class SettingsChanged extends AppEvent {
  final String customerTemplateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;
  final String gcpApiKey;

  SettingsChanged(this.customerTemplateGitRepository, this.instanceGitUsername,
      this.instanceGitToken, this.gcpApiKey);

  @override
  List<Object> get props => [
        customerTemplateGitRepository,
        instanceGitUsername,
        instanceGitToken,
        gcpApiKey
      ];
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
  final String serviceId;
  final String name;
  final String user;
  final String userEmail;
  final String owner;
  final String instanceRepo;
  final String templateName;
  final int templateId;
  final Template template;
  final String region;
  final String projectId;
  final String cloudBuildId;
  final String cloudBuildLogUrl;
  final Map<String, dynamic> params;

  ServiceDeploymentRequest({
    required this.serviceId,
    required this.name,
    required this.user,
    required this.userEmail,
    required this.owner,
    required this.instanceRepo,
    required this.templateId,
    required this.templateName,
    required this.template,
    required this.region,
    required this.projectId,
    required this.cloudBuildId,
    required this.cloudBuildLogUrl,
    required this.params,
  });

  @override
  List<Object> get props => [
        serviceId,
        name,
        user,
        userEmail,
        owner,
        instanceRepo,
        templateId,
        templateName,
        template,
        region,
        projectId,
        cloudBuildId,
        cloudBuildLogUrl,
        params
      ];
}
