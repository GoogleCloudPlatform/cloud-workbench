import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppState(
            templateGitRepository:
                "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json")) {
    on<SettingsChangedEvent>(_mapSettingsChangedEventToState);
  }

  void _mapSettingsChangedEventToState(
      SettingsChangedEvent event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        templateGitRepository: event.templateGitRepository,
        instanceGitUsername: event.instanceGitUsername,
        instanceGitToken: event.instanceGitToken,
      ),
    );
  }
}
