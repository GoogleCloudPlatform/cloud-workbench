part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    templateGitRepository,
    instanceGitUsername,
    instanceGitToken,
    appName,
    appRegion,
    gitInstanceRepo,
    myServices,
  })  : templateGitRepository = templateGitRepository,
        instanceGitUsername = instanceGitUsername ?? "",
        instanceGitToken = instanceGitToken ?? "",
        appName = appName ?? "",
        appRegion = appRegion ?? "",
        gitInstanceRepo = gitInstanceRepo ?? "",
        myServices = myServices ?? const [];

  // GitHub Settings Page
  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;
  // Services Page
  final String appName;
  final String appRegion;
  final String gitInstanceRepo;
  final List<Service> myServices;

  @override
  List<Object> get props => [
        templateGitRepository,
        instanceGitUsername,
        instanceGitToken,
        appName,
        appRegion,
        gitInstanceRepo,
        myServices,
      ];

  AppState copyWith({
    String? templateGitRepository,
    String? instanceGitUsername,
    String? instanceGitToken,
    String? appName,
    String? appRegion,
    String? gitInstanceRepo,
    List<Service>? myServices,
  }) {
    return AppState(
      templateGitRepository:
          templateGitRepository ?? this.templateGitRepository,
      instanceGitUsername: instanceGitUsername ?? this.instanceGitUsername,
      instanceGitToken: instanceGitToken ?? this.instanceGitToken,
      appName: appName ?? this.appName,
      appRegion: appRegion ?? this.appRegion,
      gitInstanceRepo: gitInstanceRepo ?? this.gitInstanceRepo,
      myServices: myServices ?? this.myServices,
    );
  }
}
