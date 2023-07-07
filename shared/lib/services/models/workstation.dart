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
