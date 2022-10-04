part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    templateGitRepository,
    instanceGitUsername,
    instanceGitToken,
    appName,
    appRegion,
    gitInstanceRepo,
    castAPI,
    castAccessToken,
    myServices,
    castApplications,
  })  : templateGitRepository = templateGitRepository ?? "",
        instanceGitUsername = instanceGitUsername ?? "",
        instanceGitToken = instanceGitToken ?? "",
        appName = appName ?? "",
        appRegion = appRegion ?? "",
        gitInstanceRepo = gitInstanceRepo ?? "",
        castAPI = castAPI ?? "",
        castAccessToken = castAccessToken ?? "",
        myServices = myServices ?? const <Service>[],
        castApplications = castApplications ?? const <CastApplication>[];

  // GitHub Settings Page
  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;
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
        templateGitRepository,
        instanceGitUsername,
        instanceGitToken,
        appName,
        appRegion,
        gitInstanceRepo,
        castAPI,
        castAccessToken,
        myServices,
        castApplications,
      ];

  AppState copyWith({
    String? templateGitRepository,
    String? instanceGitUsername,
    String? instanceGitToken,
    String? appName,
    String? appRegion,
    String? gitInstanceRepo,
    String? castAPI,
    String? castAccessToken,
    List<Service>? myServices,
    List<CastApplication>? castApplications,
  }) {
    return AppState(
      templateGitRepository:
          templateGitRepository ?? this.templateGitRepository,
      instanceGitUsername: instanceGitUsername ?? this.instanceGitUsername,
      instanceGitToken: instanceGitToken ?? this.instanceGitToken,
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
