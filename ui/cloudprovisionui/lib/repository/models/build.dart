class Build {
  String buildId;
  String status;
  String createTime;
  String finishTime;
  String buildTriggerId;
  String projectId;
  String buildLogUrl;

  Build(this.buildId, this.status, this.createTime, this.finishTime,
      this.buildTriggerId, this.projectId, this.buildLogUrl);

  Build.fromJson(Map<String, dynamic> parsedJson)
      : buildId = parsedJson['buildId'],
        status = parsedJson['status'],
        createTime = parsedJson['createTime'],
        finishTime = parsedJson['finishTime'],
        buildTriggerId = parsedJson['buildTriggerId'],
        projectId = parsedJson['projectId'],
        buildLogUrl = parsedJson['buildLogUrl'];

  Map<String, dynamic> toJson() {
    return {
      'buildId': buildId,
      'status': status,
      'createTime': createTime,
      'finishTime': finishTime,
      'buildTriggerId': buildTriggerId,
      'projectId': projectId,
      'buildLogUrl': buildLogUrl,
    };
  }
}
