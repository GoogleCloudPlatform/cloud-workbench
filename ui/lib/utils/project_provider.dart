import 'dart:async';

import 'package:cloud_provision_shared/services/ProjectService.dart';
import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../modules/auth/repositories/auth_provider.dart';

part 'project_provider.g.dart';

final projectDropdownProvider = StateProvider<String>(
      (ref) => "Select a project",
);

final projectProvider = StateProvider<Project>(
      (ref) => new Project(projectId: "null", projectNumber: "null",
      name:  "null", createTime:  DateTime.now()),
);

@riverpod
Future<List<Project>> projects(ProjectsRef ref) async {
  final authRepo = ref.watch(authRepositoryProvider);

  var authClient = await authRepo.getAuthClient();
  ProjectService projectService = new ProjectService(authClient!);
  return projectService.getProjects(authClient!);
}