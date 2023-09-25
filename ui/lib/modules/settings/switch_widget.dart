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

class TemplateRepoSwitch extends StatefulWidget {
  @override
  _TemplateRepoSwitchState createState() => _TemplateRepoSwitchState();
}

class _TemplateRepoSwitchState extends State<TemplateRepoSwitch>
    with RestorationMixin {
  RestorableBool switchValue = RestorableBool(true);

  @override
  String get restorationId => 'template_repo_switch';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(switchValue, 'switch_value');
  }

  @override
  void dispose() {
    switchValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Theme.of(context).primaryColor,
      value: switchValue.value,
      onChanged: (value) {
        setState(() {
          switchValue.value = value;
        });
      },
    );
  }
}
