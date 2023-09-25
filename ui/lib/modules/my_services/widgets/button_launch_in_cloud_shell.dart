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
