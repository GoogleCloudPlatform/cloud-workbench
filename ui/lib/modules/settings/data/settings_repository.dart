// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_provider.dart';
import 'package:cloudprovision/modules/auth/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloudprovision/shared/service/base_service.dart';
import '../models/git_settings.dart';

part 'settings_repository.g.dart';


class SettingsRepository extends BaseService {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _gitSettingsRef;

  SettingsRepository(this.firestore, this.userId, String accessToken) :
        _gitSettingsRef = firestore.collection('users/$userId/settings'),
        super.withAccessToken(accessToken);

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
      'targetProject': gitSettings.targetProject,
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

  var authClient = authRepo.getAuthClient();
  String accessToken = authClient.credentials.accessToken.data;

  return SettingsRepository(FirebaseFirestore.instance,
      authRepo.currentUser()!.uid, accessToken);
}
