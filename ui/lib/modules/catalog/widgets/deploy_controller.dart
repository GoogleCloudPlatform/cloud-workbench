import 'dart:async';
import 'package:cloudprovision/modules/catalog/application/catalog_service.dart';
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

    return await _catalogService.deployTemplate(template, formFieldValues, appId);
  }
}