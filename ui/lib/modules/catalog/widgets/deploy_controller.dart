import 'dart:async';
import 'package:cloud_provision_shared/services/models/project.dart';
import 'package:cloudprovision/modules/catalog/application/catalog_service.dart';
import 'package:cloudprovision/modules/settings/application/project_service.dart';
import 'package:cloudprovision/modules/settings/data/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_provision_shared/catalog/models/template.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deploy_controller.g.dart';

@riverpod
class DeployController extends _$DeployController {
  @override
  FutureOr<void> build() {
  }

  CatalogService get _catalogService => ref.read(catalogServiceProvider);

  Future<bool> deployTemplate(Template template,
      Map<String, String> formFieldValues, String appId) async {
    state = const AsyncValue.loading();

    Project project = ref.read(projectProvider);
    bool opStatus = await ref.read(projectServiceProvider).bootstrapTargetProject(project);

    if (opStatus) {
      opStatus = await _catalogService.deployTemplate(template, formFieldValues, appId);
    } else {
      print("Failed to bootstrap project: ${project.projectId}");
    }

    return opStatus;
  }
}