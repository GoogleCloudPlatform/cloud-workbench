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

import 'dart:async';

import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/repositories/auth_provider.dart';
import '../../auth/repositories/auth_repository.dart';
import 'project_repository.dart';

part 'project_provider.g.dart';

final projectDropdownProvider = StateProvider<String>(
      (ref) => "Select a project",
);

Project emptyProject = new Project(projectId: "null", projectNumber: "null",
name:  "null", createTime:  DateTime.now());

final projectProvider = StateProvider<Project>(
      (ref) => emptyProject,
);

@riverpod
Future<List<Project>> projects(ProjectsRef ref) async {
  final authRepo = ref.watch(authRepositoryProvider);

  try {
    var authClient = await authRepo.getAuthClient();
    ProjectService projectService = new ProjectService(authClient!.credentials.accessToken.data);
    return projectService.getProjects();
  } catch (e) {
    print(e);
    return [];
  }

}


@riverpod
ProjectRepository projectRepository(ProjectRepositoryRef ref) {
  final AuthRepository authRepo = ref.read(authRepositoryProvider);

  var authClient = authRepo.getAuthClient();
  String accessToken = authClient.credentials.accessToken.data;

  return ProjectRepository(accessToken);
}