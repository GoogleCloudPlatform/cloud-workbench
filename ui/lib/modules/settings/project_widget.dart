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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/project_provider.dart';

class ProjectWidget extends ConsumerStatefulWidget {
  final WidgetRef parentRef;
  final String initialValue;

  const ProjectWidget(this.parentRef, this.initialValue, {super.key});

  @override
  ConsumerState<ProjectWidget> createState() =>
      _ProjectState();
}

class _ProjectState extends ConsumerState<ProjectWidget> {
  final _keyWS = GlobalKey<FormState>();

  _ProjectState() {}

  @override
  Widget build(BuildContext parentContext) {
    return Form(
      key: _keyWS,
      child: _projects(),
    );
  }

  Widget _projects() {

    final projectsList = ref.watch(projectsProvider);

    TextEditingController _projectController = TextEditingController();
    _projectController.text = widget.initialValue;

    return projectsList.when(
        loading: () => LinearProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (projects) {
          if (projects.isNotEmpty) {
            var projectNames = projects.map<String>((e) => e.name).toList();

            var selectProjectText = "Select a project";
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: _projectController.text.toString()),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return projectNames.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },

              onSelected: (String value) {
                _projectController.text = value!;

                widget.parentRef.read(projectProvider.notifier).state =
                    projects.where((project) => project.name == value!).first;
              },
            );
          } else {
            return Container();
          }
        });
  }
}
