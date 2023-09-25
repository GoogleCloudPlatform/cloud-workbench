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

class Build {
  String buildId;
  String status;
  String createTime;
  String buildTriggerId;
  String projectId;
  String buildLogUrl;

  Build(this.buildId, this.status, this.createTime,
      this.buildTriggerId, this.projectId, this.buildLogUrl);

  Build.fromJson(Map<String, dynamic> parsedJson)
      : buildId = parsedJson['buildId'],
        status = parsedJson['status'],
        createTime = parsedJson['createTime'],
        buildTriggerId = parsedJson['buildTriggerId'],
        projectId = parsedJson['projectId'],
        buildLogUrl = parsedJson['buildLogUrl'];

  Map<String, dynamic> toJson() {
    return {
      'buildId': buildId,
      'status': status,
      'createTime': createTime,
      'buildTriggerId': buildTriggerId,
      'projectId': projectId,
      'buildLogUrl': buildLogUrl,
    };
  }
}
