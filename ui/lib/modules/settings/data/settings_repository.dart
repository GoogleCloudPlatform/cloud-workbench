import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_provider.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/git_settings.dart';

part 'settings_repository.g.dart';


class SettingsRepository {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _gitSettingsRef;

  SettingsRepository(this.firestore, this.userId)
      : _gitSettingsRef = firestore.collection('users/$userId/settings');

  Future<GitSettings> loadGitSettings() async {
    var document = _gitSettingsRef.doc('/git');
    var snapshot = await document.get();

    if (!snapshot.exists) {
      await document.set({
        'instanceGitUsername': "",
        'instanceGitToken': "",
        'customerTemplateGitRepository': "",
        'gcpApiKey': "",
        'updatedDate': FieldValue.serverTimestamp(),
        'createdDate': FieldValue.serverTimestamp(),
      });

      document = _gitSettingsRef.doc("git");
      snapshot = await document.get();
    }

    return GitSettings.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  updateGitSettings(GitSettings gitSettings) async {
    var document = _gitSettingsRef.doc('/git');
    var snapshot = await document.get();

    await document.set({
      'instanceGitUsername': gitSettings.instanceGitUsername,
      'instanceGitToken': gitSettings.instanceGitToken,
      'customerTemplateGitRepository':
          gitSettings.customerTemplateGitRepository,
      'gcpApiKey': gitSettings.gcpApiKey,
      'updatedDate': FieldValue.serverTimestamp(),
      'createdDate': snapshot.exists
          ? snapshot.get("createdDate")
          : FieldValue.serverTimestamp(),
    });

    document = _gitSettingsRef.doc("git");
    snapshot = await document.get();

    return GitSettings.fromJson(snapshot.data()!)..id = snapshot.id;
  }
}

@riverpod
Future<GitSettings> gitSettings(GitSettingsRef ref) {
  final SettingsRepository settingsRepository = ref.read(settingsRepositoryProvider);
  return settingsRepository.loadGitSettings();
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final AuthRepository authRepo = ref.read(authRepositoryProvider);
  return SettingsRepository(FirebaseFirestore.instance, authRepo.currentUser()!.uid);
}
