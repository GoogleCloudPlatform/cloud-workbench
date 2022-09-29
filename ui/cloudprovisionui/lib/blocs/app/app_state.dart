part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({templateGitRepository, instanceGitUsername, instanceGitToken})
      : templateGitRepository = templateGitRepository,
        instanceGitUsername = instanceGitUsername ?? "",
        instanceGitToken = instanceGitToken ?? "";

  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;

  @override
  List<Object> get props =>
      [templateGitRepository, instanceGitUsername, instanceGitToken];

  AppState copyWith(
      {String? templateGitRepository,
      String? instanceGitUsername,
      String? instanceGitToken}) {
    return AppState(
      templateGitRepository:
          templateGitRepository ?? this.templateGitRepository,
      instanceGitUsername: instanceGitUsername ?? this.instanceGitUsername,
      instanceGitToken: instanceGitToken ?? this.instanceGitToken,
    );
  }
}
