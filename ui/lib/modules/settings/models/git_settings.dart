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

class GitSettings {
  String? id;
  String instanceGitUsername;
  String instanceGitToken;
  String customerTemplateGitRepository;
  String gcpApiKey;
  String targetProject;

  GitSettings(
    this.instanceGitUsername,
    this.instanceGitToken,
    this.customerTemplateGitRepository,
    this.gcpApiKey, this.targetProject,
  );

  GitSettings.fromJson(Map<String, dynamic> parsedJson)
      : instanceGitUsername = parsedJson['instanceGitUsername'],
        instanceGitToken = parsedJson['instanceGitToken'],
        customerTemplateGitRepository =
            parsedJson['customerTemplateGitRepository'],
        gcpApiKey = parsedJson['gcpApiKey'],
        targetProject = parsedJson['targetProject'] != null ? parsedJson['targetProject'] : "";

  Map<String, dynamic> toJson() {
    return {
      'instanceGitUsername': instanceGitUsername,
      'instanceGitToken': instanceGitToken,
      'customerTemplateGitRepository': customerTemplateGitRepository,
      'gcpApiKey': gcpApiKey,
      'targetProject': targetProject,
    };
  }
}
