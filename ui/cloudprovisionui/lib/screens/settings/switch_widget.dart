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
