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
import 'template_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'template_repository.g.dart';

class TemplateRepository {
  const TemplateRepository({required this.service});

  final TemplateService service;

  /// Returns list of templates
  Future<List<Template>> loadTemplates() async =>
      service.loadTemplates();

  /// Returns template by id
  ///
  /// [templateId]
  Future<Template> loadTemplateById(
          int templateId, String catalogSource) async =>
      service.loadTemplateById(templateId, catalogSource);
}



@riverpod
class Tags extends _$Tags {
  @override
  List<String> build() {
    return [];
  }

  void addTag(String tag) {
    state = [...state, tag];
  }

  void removeTag(String tag) {
    if (tag == "*") {
      state = [];
    } else {
      state = [...state.where((element) => element != tag)];
    }
  }
}

@riverpod
Future<List<Template>> templates(TemplatesRef ref) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  return templateRepository.loadTemplates();
}

@riverpod
Future<Template> templateById(TemplateByIdRef ref, int templateId, String catalogSource) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  return templateRepository.loadTemplateById(templateId, catalogSource);
}

@riverpod
TemplateRepository templateRepository(TemplateRepositoryRef ref) {
  return TemplateRepository(service: TemplateService());
}