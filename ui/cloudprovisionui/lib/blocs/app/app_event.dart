part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class SettingsChangedEvent extends AppEvent {
  final String templateGitRepository;
  final String instanceGitUsername;
  final String instanceGitToken;

  SettingsChangedEvent(this.templateGitRepository, this.instanceGitUsername,
      this.instanceGitToken);

  @override
  List<Object> get props =>
      [templateGitRepository, instanceGitUsername, instanceGitToken];
}
