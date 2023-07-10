import 'dart:async';

import 'package:cloudprovision/modules/settings/models/git_settings.dart';
import 'package:cloudprovision/modules/settings/data/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitOwnersDropdown extends ConsumerStatefulWidget {
  const GitOwnersDropdown({super.key, required this.onTextFormUpdate});

  final Function onTextFormUpdate;

  @override
  ConsumerState<GitOwnersDropdown> createState() => _GitOwnersDropdownState();
}

class _GitOwnersDropdownState extends ConsumerState<GitOwnersDropdown> {
  late String dropdownValue;

  _GitOwnersDropdownState() {
    dropdownValue = "Select an owner";
  }

  Future<GitSettings> getSettings() async {
    GitSettings gitSettings =
        await ref.read(settingsRepositoryProvider).loadGitSettings();
    return gitSettings;
  }

  @override
  Widget build(BuildContext parentContext) {
    final asyncGitSettingsValue = ref.watch(gitSettingsProvider);

    return asyncGitSettingsValue.when(
      data: (gitSettings) {
        return SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value == "Select an owner") {
                return 'This field is required';
              }
              return null;
            },
            hint: Text("Select an owner"),
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            style: const TextStyle(color: Colors.black),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                widget.onTextFormUpdate(
                    value, "_INSTANCE_GIT_REPO_OWNER");
              });
            },
            items: [
              "Select an owner",
              "https://github.com/${gitSettings.instanceGitUsername}"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, st) => Center(
        child: Text(
          err.toString(),
        ),
      ),
    );
  }
}
