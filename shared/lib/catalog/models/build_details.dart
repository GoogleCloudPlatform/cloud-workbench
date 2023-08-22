class BuildDetails {
  String id;
  String logUrl;

  BuildDetails(this.id, this.logUrl);

  BuildDetails.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        logUrl = parsedJson['logUrl'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logUrl': logUrl,
    };
  }
}
