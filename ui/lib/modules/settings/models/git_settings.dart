class GitSettings {
  String? id;
  String instanceGitUsername;
  String instanceGitToken;
  String customerTemplateGitRepository;
  String gcpApiKey;
  String targetProject;

  GitSettings(
    this.instanceGitUsername,
    this.instanceGitToken,
    this.customerTemplateGitRepository,
    this.gcpApiKey, this.targetProject,
  );

  GitSettings.fromJson(Map<String, dynamic> parsedJson)
      : instanceGitUsername = parsedJson['instanceGitUsername'],
        instanceGitToken = parsedJson['instanceGitToken'],
        customerTemplateGitRepository =
            parsedJson['customerTemplateGitRepository'],
        gcpApiKey = parsedJson['gcpApiKey'],
        targetProject = parsedJson['targetProject'] != null ? parsedJson['targetProject'] : "";

  Map<String, dynamic> toJson() {
    return {
      'instanceGitUsername': instanceGitUsername,
      'instanceGitToken': instanceGitToken,
      'customerTemplateGitRepository': customerTemplateGitRepository,
      'gcpApiKey': gcpApiKey,
      'targetProject': targetProject,
    };
  }
}
