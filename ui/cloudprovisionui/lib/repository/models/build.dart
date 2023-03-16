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
