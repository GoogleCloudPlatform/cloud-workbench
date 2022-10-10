import 'package:cloudprovision/repository/firebase_repository.dart';
import 'package:cloudprovision/repository/models/cast_application.dart';
import 'package:cloudprovision/repository/models/git_settings.dart';
import 'package:cloudprovision/repository/models/service.dart';
import 'package:cloudprovision/repository/service/cast_highlight_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseRepository firebaseRepository;

  AppBloc({required this.firebaseRepository})
      : super(AppState(
          castAPI: "https://demo.casthighlight.com/WS2",
          gcpTemplateGitRepository:
              "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json",
          communityTemplateGitRepository:
              "https://raw.githubusercontent.com/gitrey/community-templates/main/templates.json",
        )) {
    on<GetAppState>(_mapGetAppEventToState);
    on<SettingsChanged>(_mapSettingsChangedEventToState);
    on<ServiceDeploymentRequest>(_mapServiceDeploymentRequestEventToState);
    on<GetMyServices>(_mapGetMyServicesEventToState);
    on<CastSettingsChanged>(_mapCastSettingsChangedEventToState);
    on<LoadCastAssessment>(_mapLoadCastAssessmentEventToState);
  }

  void _mapGetAppEventToState(GetAppState event, Emitter<AppState> emit) async {
    GitSettings gitSettings = await firebaseRepository.loadGitSettings();

    emit(
      state.copyWith(
        customerTemplateGitRepository:
            gitSettings.customerTemplateGitRepository,
        instanceGitUsername: gitSettings.instanceGitUsername,
        instanceGitToken: gitSettings.instanceGitToken,
        gcpApiKey: gitSettings.gcpApiKey,
      ),
    );
  }

  void _mapSettingsChangedEventToState(
      SettingsChanged event, Emitter<AppState> emit) async {
    GitSettings gitSettings = GitSettings(
      event.instanceGitUsername,
      event.instanceGitToken,
      event.customerTemplateGitRepository,
      event.gcpApiKey,
    );

    firebaseRepository.updateGitSettings(gitSettings);

    emit(
      state.copyWith(
        customerTemplateGitRepository: event.customerTemplateGitRepository,
        instanceGitUsername: event.instanceGitUsername,
        instanceGitToken: event.instanceGitToken,
        gcpApiKey: event.gcpApiKey,
      ),
    );
  }

  void _mapCastSettingsChangedEventToState(
      CastSettingsChanged event, Emitter<AppState> emit) async {
    emit(
      state.copyWith(
        castAPI: event.castAPI,
        castAccessToken: event.castAccessToken,
      ),
    );
  }

  void _mapLoadCastAssessmentEventToState(
      LoadCastAssessment event, Emitter<AppState> emit) async {
    CastHighlightService castHighlightService = CastHighlightService();
    List<CastApplication> castApplications = await castHighlightService
        .loadAssessmentByCampaignId(event.campaignId, event.castAccessToken);

    emit(
      state.copyWith(
        castApplications: castApplications,
      ),
    );
  }

  void _mapServiceDeploymentRequestEventToState(
      ServiceDeploymentRequest event, Emitter<AppState> emit) async {
    Service deployedService = Service(
      name: event.name,
      owner: event.owner,
      instanceRepo: event.instanceRepo,
      templateId: event.templateId,
      templateName: event.templateName,
      region: event.region,
      projectId: event.projectId,
      cloudBuildId: event.cloudBuildId,
      cloudBuildLogUrl: event.cloudBuildLogUrl,
      params: event.params,
      deploymentDate: DateTime.now(),
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

  void _mapGetMyServicesEventToState(
      GetMyServices event, Emitter<AppState> emit) async {
    List<Service> services = await firebaseRepository.loadServices();

    emit(
      state.copyWith(
        myServices: services,
      ),
    );
  }
}
