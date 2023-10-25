import 'dart:convert';
import 'dart:io';

import 'package:cloud_provision_shared/services/BuildsService.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('BuildsService', () {
    test('test getBuildRequest from json config', () async {
      // Load json from file
      final file = new File('./test/ConfigService/ConfigService_testfile.json')
          .readAsStringSync();

      var jsonConfig = json.decode(file.toString());

      var subs = <String, String>{
        "_REGION": "us-east1",
        "_INSTANCE_GIT_REPO_OWNER": "testGit",
        "_APP_NAME": "testing",
        "_INSTANCE_GIT_REPO_TOKEN": "no_token",
        "_API_KEY": "secretkey",
        "_APP_ID": "id",
      };
      var build = await BuildsService("1234")
          .getBuildRequest(jsonConfig, "DELETE", subs);

      expect(
          build.steps?.indexWhere((element) => element.id == "Inspect Values"),
          equals(0));
      expect(
          build.steps?.indexWhere((element) => element.id == "clone templates"),
          equals(1));
      expect(build.steps?.indexWhere((element) => element.id == "clone utils"),
          equals(2));
      expect(build.steps?.indexWhere((element) => element.id == "cleanup"),
          equals(3));
    }, skip: false);
    test('test getBuildRequest from yaml config', () async {
      // Load json from file
      final file = new File('./test/ConfigService/ConfigService_testfile.yaml')
          .readAsStringSync();
      var yamlDoc = loadYaml(file.toString());

      var jsonConfig = json.decode(json.encode(yamlDoc));

      var subs = <String, String>{
        "_REGION": "us-east1",
        "_INSTANCE_GIT_REPO_OWNER": "testGit",
        "_APP_NAME": "testing",
        "_INSTANCE_GIT_REPO_TOKEN": "no_token",
        "_API_KEY": "secretkey",
        "_APP_ID": "id",
      };
      var build = await BuildsService("1234")
          .getBuildRequest(jsonConfig, "DELETE", subs);

      expect(
          build.steps?.indexWhere((element) => element.id == "Inspect Values"),
          equals(0));
      expect(
          build.steps?.indexWhere((element) => element.id == "clone templates"),
          equals(1));
      expect(build.steps?.indexWhere((element) => element.id == "clone utils"),
          equals(2));
      expect(build.steps?.indexWhere((element) => element.id == "cleanup"),
          equals(3));
    }, skip: false);
  });
}
