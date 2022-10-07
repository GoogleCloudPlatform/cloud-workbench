import 'package:cloud_firestore/cloud_firestore.dart';

class GitSettings {
  String? id;
  String instanceGitUsername;
  String instanceGitToken;
  String customerTemplateGitRepository;
  String gcpApiKey;

  GitSettings(
    this.instanceGitUsername,
    this.instanceGitToken,
    this.customerTemplateGitRepository,
    this.gcpApiKey,
  );

  GitSettings.fromJson(Map<String, dynamic> parsedJson)
      : instanceGitUsername = parsedJson['instanceGitUsername'],
        instanceGitToken = parsedJson['instanceGitToken'],
        customerTemplateGitRepository =
            parsedJson['customerTemplateGitRepository'],
        gcpApiKey = parsedJson['gcpApiKey'];

  Map<String, dynamic> toJson() {
    return {
      'instanceGitUsername': instanceGitUsername,
      'instanceGitToken': instanceGitToken,
      'customerTemplateGitRepository': customerTemplateGitRepository,
      'gcpApiKey': gcpApiKey,
    };
  }
}
