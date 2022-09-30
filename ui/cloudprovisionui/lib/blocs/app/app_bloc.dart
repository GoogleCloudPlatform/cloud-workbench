import 'package:cloudprovision/repository/models/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(AppState(
            templateGitRepository:
                "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json",
            appName: "",
            appRegion: "",
            gitInstanceRepo: "",
            instanceGitUsername: "",
            myServices: <Service>[])) {
    on<SettingsChangedEvent>(_mapSettingsChangedEventToState);
    on<ServiceDeployedEvent>(_mapServiceDeployedEventToState);
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

  void _mapServiceDeployedEventToState(
      ServiceDeployedEvent event, Emitter<AppState> emit) async {
    Service deployedService = Service(
      event.name,
      event.owner,
      event.templateName,
      event.instanceRepo,
      event.region,
      event.projectId,
      DateTime.now(),
    );

    List<Service> updatedList = new List<Service>.from(state.myServices)
      ..add(deployedService);

    emit(
      state.copyWith(
        myServices: updatedList,
      ),
    );
  }
}
