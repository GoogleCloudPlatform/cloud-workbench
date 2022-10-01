import 'package:cloudprovision/repository/firebase_repository.dart';
import 'package:cloudprovision/repository/models/git_settings.dart';
import 'package:cloudprovision/repository/models/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseRepository firebaseRepository;

  AppBloc({required this.firebaseRepository}) : super(AppState(
            // templateGitRepository:
            //     "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json",
            /*myServices: [
              Service(
                  "go-app-demo",
                  "Andrey Shakirov",
                  "Onboard Go Application (Cloud Run)",
                  "https://github.com/gitrey/cp-templates",
                  "us-east1",
                  "andrey-cp-8-9",
                  DateTime.now()),
              Service(
                  "go-demo-application",
                  "Andrey Shakirov",
                  "Onboard Go Application (Cloud Run)",
                  "https://github.com/gitrey/go-demo-application",
                  "us-west4",
                  "andrey-cp-8-9",
                  DateTime.now()),
              Service(
                  "go-demo-application",
                  "Andrey Shakirov",
                  "Onboard Go Application (Cloud Run)",
                  "https://github.com/gitrey/go-demo-application",
                  "us-west4",
                  "andrey-cp-8-9",
                  DateTime.now()),
              Service(
                  "go-demo-application",
                  "Andrey Shakirov",
                  "Onboard Go Application (Cloud Run)",
                  "https://github.com/gitrey/go-demo-application",
                  "us-west4",
                  "andrey-cp-8-9",
                  DateTime.now()),
              Service(
                  "go-demo-application",
                  "Andrey Shakirov",
                  "Onboard Go Application (Cloud Run)",
                  "https://github.com/gitrey/go-demo-application",
                  "us-west4",
                  "andrey-cp-8-9",
                  DateTime.now()),
            ]*/
            )) {
    on<GetAppState>(_mapGetAppEventToState);
    on<SettingsChangedEvent>(_mapSettingsChangedEventToState);
    on<ServiceDeployedEvent>(_mapServiceDeployedEventToState);
  }

  void _mapGetAppEventToState(GetAppState event, Emitter<AppState> emit) async {
    GitSettings gitSettings = await firebaseRepository.loadGitSettings();

    emit(
      state.copyWith(
        templateGitRepository: gitSettings.templateGitRepository,
        instanceGitUsername: gitSettings.instanceGitUsername,
        instanceGitToken: gitSettings.instanceGitToken,
      ),
    );

    print("_mapGetAppEventToState ${gitSettings}");
  }

  void _mapSettingsChangedEventToState(
      SettingsChangedEvent event, Emitter<AppState> emit) async {
    print("_mapSettingsChangedEventToState ${event}");

    GitSettings gitSettings = GitSettings(
      event.instanceGitUsername,
      event.instanceGitToken,
      event.templateGitRepository,
    );

    firebaseRepository.updateGitSettings(gitSettings);

    emit(
      state.copyWith(
        templateGitRepository: event.templateGitRepository,
        instanceGitUsername: event.instanceGitUsername,
        instanceGitToken: event.instanceGitToken,
      ),
    );

    print("_mapSettingsChangedEventToState ${gitSettings}");
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

    firebaseRepository.addService(deployedService);

    emit(
      state.copyWith(
        myServices: updatedList,
      ),
    );
  }
}
