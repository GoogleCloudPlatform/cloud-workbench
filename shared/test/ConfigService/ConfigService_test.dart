import 'dart:io';

import 'package:cloud_provision_shared/services/ConfigService.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'ConfigService_test.mocks.dart';

// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
void main() {
  group('ConfigService', () {
    test('return json on succesfull http call - default client', () async {
      var buildSteps = await ConfigService().getJson(
          'https://raw.githubusercontent.com/gitrey/cp-templates/main/infra/pubsub/cloudprovision.json');

      expect(buildSteps.length, greaterThanOrEqualTo(4));
    }, skip: false);
    test('return json on succesfull http call - with mock', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'https://raw.githubusercontent.com/gitrey/cp-templates/main/infra/pubsub/cloudprovision.json')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      var buildSteps = await ConfigService().getJson(
          'https://raw.githubusercontent.com/gitrey/cp-templates/main/infra/pubsub/cloudprovision.json',
          client);

      expect(buildSteps.length, greaterThanOrEqualTo(3));
    }, skip: false);
    test('return yaml on succesfull http call - with mock', () async {
      final client = MockClient();

      // Load yaml from file
      final file = new File('./test/ConfigService/ConfigService_testfile.yaml')
          .readAsStringSync();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'https://raw.githubusercontent.com/gitrey/cp-templates/main/infra/pubsub/cloudprovision.yaml')))
          .thenAnswer((_) async => http.Response(file.toString(), 200));

      var buildSteps = await ConfigService().getJson(
          'https://raw.githubusercontent.com/gitrey/cp-templates/main/infra/pubsub/cloudprovision.yaml',
          client);

      expect(buildSteps.length, greaterThanOrEqualTo(4));
    }, skip: false);
  });
}
