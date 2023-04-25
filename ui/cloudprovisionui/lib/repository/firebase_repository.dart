import 'models/git_settings.dart';
import 'models/service.dart';
import 'service/firebase_service.dart';

class FirebaseRepository {
  const FirebaseRepository({required this.service});

  final FirebaseService service;

  /// Returns list of services
  Future<List<Service>> loadServices() async => service.loadServices();

  /// Creates new service
  ///
  /// [deployedService]
  Future<void> addService(Service deployedService) async =>
      service.addService(deployedService);

  /// Updates Git Settings
  ///
  /// [GitSettings]
  Future<void> updateGitSettings(GitSettings gitSettings) async =>
      service.updateGitSettings(gitSettings);

  /// Returns Application Settings
  Future<GitSettings> loadGitSettings() async => service.loadGitSettings();
}
