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
      name: json["name"],
      projectId: json["projectId"],
      projectNumber: json["projectNumber"],
      createTime: DateTime.parse(json["createTime"]),
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