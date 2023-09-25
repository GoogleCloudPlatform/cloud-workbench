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

class Workstation {
  String name;
  String uid;
  String displayName;
  String etag;
  String state;
  String host;
  DateTime createTime;
  DateTime updateTime;
  String location;
  String clusterName;
  String configName;

  Workstation(
      {required this.name,
      required this.displayName,
      required this.uid,
      required this.etag,
      required this.state,
      required this.host,
      required this.createTime,
      required this.updateTime,
      required this.location,
      required this.clusterName,
      required this.configName});

  factory Workstation.fromJson(Map<String, dynamic> json) {
    

    return Workstation(
      name: json["name"],
      displayName: json["displayName"],
      uid: json["uid"],
      etag: json["etag"],
      state: json["state"],
      host: json["host"],
      createTime: DateTime.parse(json["createTime"]),
      updateTime: DateTime.parse(json["updateTime"]),
      location: json["location"],
      clusterName: json["clusterName"],
      configName: json["configName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "displayName": this.displayName,
      "uid": this.uid,
      "etag": this.etag,
      "state": this.state,
      "host": this.host,
      "createTime": this.createTime.toIso8601String(),
      "updateTime": this.updateTime.toIso8601String(),
      "location": this.location,
      "clusterName": this.clusterName,
      "configName": this.configName,
    };
  }

//
}
