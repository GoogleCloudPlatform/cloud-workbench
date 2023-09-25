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

class Cluster {
  String name;
  String uid;
  DateTime createTime;
  DateTime updateTime;
  String etag;
  String network;
  String subnetwork;
  String controlPlaneIp;

  Cluster({required this.name, required this.uid, required this.createTime,
    required this.updateTime, required this.etag, required this.network,
    required this.subnetwork, required this.controlPlaneIp
  });

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      name: json["name"],
      uid: json["uid"],
      createTime: DateTime.parse(json["createTime"]),
      updateTime: DateTime.parse(json["updateTime"]),
      etag: json["etag"],
      network: json["network"],
      subnetwork: json["subnetwork"],
      controlPlaneIp: json["controlPlaneIp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "uid": this.uid,
      "createTime": this.createTime.toIso8601String(),
      "updateTime": this.updateTime.toIso8601String(),
      "etag": this.etag,
      "network": this.network,
      "subnetwork": this.subnetwork,
      "controlPlaneIp": this.controlPlaneIp,
    };
  }

//
}