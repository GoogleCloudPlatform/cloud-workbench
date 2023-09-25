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

class Project {
  String name;
  String projectId;
  String projectNumber;
  DateTime createTime;

  Project({required this.name, required this.projectId, required this.createTime,
    required this.projectNumber,

  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json["name"] != null ? json["name"] : json["projectNumber"],
      projectId: json["projectId"] != null ? json["projectId"] : "",
      projectNumber: json["projectNumber"] != null ? json["projectNumber"] : "",
      createTime: json["createTime"] != null ? DateTime.parse(json["createTime"]) : DateTime.timestamp(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "projectId": this.projectId,
      "projectNumber": this.projectNumber,
      "createTime": this.createTime.toIso8601String(),
    };
  }
}