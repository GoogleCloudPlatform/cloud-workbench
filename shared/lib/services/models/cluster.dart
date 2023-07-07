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