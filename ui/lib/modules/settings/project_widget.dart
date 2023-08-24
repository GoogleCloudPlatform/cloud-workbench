import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/project_provider.dart';

class ProjectWidget extends ConsumerStatefulWidget {
  const ProjectWidget({super.key});

  @override
  ConsumerState<ProjectWidget> createState() =>
      _ProjectState();
}

class _ProjectState extends ConsumerState<ProjectWidget> {
  final _keyWS = GlobalKey<FormState>();

  _ProjectState() {}

  @override
  Widget build(BuildContext parentContext) {
    return _projectSection();
  }

  Widget _projectSection() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    child: Form(
                      key: _keyWS,
                      child: Column(
                        children: [
                          _projects(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _projects() {

    final projectsList = ref.watch(projectsProvider);

    return projectsList.when(
        loading: () => Container(),
        error: (err, stack) => Container(),
        data: (projects) {
          if (projects.isNotEmpty) {
            var projectNames = projects.map<String>((e) => e.name).toList();

            var selectProjectText = "Select a project";
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              return null;
                            },
                            hint: Text(selectProjectText),
                            value: selectProjectText,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? value) {
                              ref.read(projectDropdownProvider.notifier).state =
                                  value!;

                              ref.read(projectProvider.notifier).state =
                              projects.where((project) => project.name == value!).first;
                            },
                            items: [selectProjectText, ...projectNames]
                                .map<DropdownMenuItem<String>>(
                                    (String projectName) {
                              return DropdownMenuItem<String>(
                                value: projectName,
                                child: Text(projectName),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
