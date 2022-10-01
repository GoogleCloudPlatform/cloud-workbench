import 'package:cloud_firestore/cloud_firestore.dart';

class GitSettings {
  String? id;
  String instanceGitUsername;
  String instanceGitToken;
  String templateGitRepository;

  GitSettings(
    this.instanceGitUsername,
    this.instanceGitToken,
    this.templateGitRepository,
  );

  GitSettings.fromJson(Map<String, dynamic> parsedJson)
      : instanceGitUsername = parsedJson['instanceGitUsername'],
        instanceGitToken = parsedJson['instanceGitToken'],
        templateGitRepository = parsedJson['templateGitRepository'];

  Map<String, dynamic> toJson() {
    return {
      'instanceGitUsername': instanceGitUsername,
      'instanceGitToken': instanceGitToken,
      'templateGitRepository': templateGitRepository,
    };
  }

  @override
  String toString() {
    return 'GitSettings{id: $id, instanceGitUsername: $instanceGitUsername, instanceGitToken: $instanceGitToken, templateGitRepository: $templateGitRepository}';
  }
}
