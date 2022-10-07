part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    gcpTemplateGitRepository,
    customerTemplateGitRepository,
    communityTemplateGitRepository,
    instanceGitUsername,
    instanceGitToken,
    gcpApiKey,
    appName,
    appRegion,
    gitInstanceRepo,
    castAPI,
    castAccessToken,
    myServices,
    castApplications,
  })  : gcpTemplateGitRepository = gcpTemplateGitRepository ?? "",
        customerTemplateGitRepository = customerTemplateGitRepository ?? "",
        communityTemplateGitRepository = communityTemplateGitRepository ?? "",
        instanceGitUsername = instanceGitUsername ?? "",
        instanceGitToken = instanceGitToken ?? "",
        gcpApiKey = gcpApiKey ?? "",
        appName = appName ?? "",
        appRegion = appRegion ?? "",
        gitInstanceRepo = gitInstanceRepo ?? "",
        castAPI = castAPI ?? "",
        castAccessToken = castAccessToken ?? "",
        myServices = myServices ?? const <Service>[],
        castApplications = castApplications ?? const <CastApplication>[];

  // GitHub Settings Page
  final String customerTemplateGitRepository;
  final String communityTemplateGitRepository;
  final String gcpTemplateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;
  final String gcpApiKey;
  // CAST Settings Page
  final String castAPI;
  final String castAccessToken;
  // Services Page
  final String appName;
  final String appRegion;
  final String gitInstanceRepo;
  final List<Service> myServices;
  // CAST Highlight
  final List<CastApplication> castApplications;

  @override
  List<Object> get props => [
        gcpTemplateGitRepository,
        customerTemplateGitRepository,
        communityTemplateGitRepository,
        instanceGitUsername,
        instanceGitToken,
        gcpApiKey,
        appName,
        appRegion,
        gitInstanceRepo,
        castAPI,
        castAccessToken,
        myServices,
        castApplications,
      ];

  AppState copyWith({
    String? gcpTemplateGitRepository,
    String? customerTemplateGitRepository,
    String? communityTemplateGitRepository,
    String? instanceGitUsername,
    String? instanceGitToken,
    String? gcpApiKey,
    String? appName,
    String? appRegion,
    String? gitInstanceRepo,
    String? castAPI,
    String? castAccessToken,
    List<Service>? myServices,
    List<CastApplication>? castApplications,
  }) {
    return AppState(
      gcpTemplateGitRepository:
          gcpTemplateGitRepository ?? this.gcpTemplateGitRepository,
      customerTemplateGitRepository:
          customerTemplateGitRepository ?? this.customerTemplateGitRepository,
      communityTemplateGitRepository:
          communityTemplateGitRepository ?? this.communityTemplateGitRepository,
      instanceGitUsername: instanceGitUsername ?? this.instanceGitUsername,
      instanceGitToken: instanceGitToken ?? this.instanceGitToken,
      gcpApiKey: gcpApiKey ?? this.gcpApiKey,
      appName: appName ?? this.appName,
      appRegion: appRegion ?? this.appRegion,
      gitInstanceRepo: gitInstanceRepo ?? this.gitInstanceRepo,
      castAPI: castAPI ?? this.castAPI,
      castAccessToken: castAccessToken ?? this.castAccessToken,
      myServices: myServices ?? this.myServices,
      castApplications: castApplications ?? this.castApplications,
    );
  }
}
