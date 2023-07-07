import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/service.dart';

class LaunchInCloudShellButton extends StatelessWidget {
  final Service service;
  const LaunchInCloudShellButton({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image(
                  color: Colors.white,
                  image: AssetImage('images/cloud_shell.png'),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 5),
              Text("DEVELOP IN GOOGLE CLOUD SHELL")
            ],
          ),
          onPressed: () async {
            final Uri _url = Uri.parse(
                "https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=${service.instanceRepo}&cloudshell_workspace=.");
            if (!await launchUrl(_url)) {
              throw 'Could not launch $_url';
            }
          },
        ),
      ],
    );
  }
}
