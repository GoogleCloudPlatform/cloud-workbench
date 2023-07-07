class WorkstationConfig {
  String name;
  String uid;
  DateTime createTime;
  DateTime updateTime;
  String etag;
  String idleTimeout;
  String runningTimeout;

  WorkstationConfig({required this.name, required this.uid, required this.createTime,
    required this.updateTime, required this.etag, required this.idleTimeout,
    required this.runningTimeout
  });

  factory WorkstationConfig.fromJson(Map<String, dynamic> json) {
    return WorkstationConfig(
      name: json["name"],
      uid: json["uid"],
      createTime: DateTime.parse(json["createTime"]),
      updateTime: DateTime.parse(json["updateTime"]),
      etag: json["etag"],
      idleTimeout: json["idleTimeout"],
      runningTimeout: json["runningTimeout"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "uid": this.uid,
      "createTime": this.createTime.toIso8601String(),
      "updateTime": this.updateTime.toIso8601String(),
      "etag": this.etag,
      "idleTimeout": this.idleTimeout,
      "runningTimeout": this.runningTimeout,
    };
  }
//

//
}