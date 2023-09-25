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

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/catalog_service.dart';

part 'catalog_controller.g.dart';

@riverpod
class CatalogController extends _$CatalogController {
  @override
  FutureOr<void> build() {}

  CatalogService get catalogService => ref.read(catalogServiceProvider);

  Future<List<Template>> loadTemplates() {
    return catalogService.loadTemplates();
  }

  Future<Template> templateById() {
    return catalogService.templateById();
  }
}
