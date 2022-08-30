import 'package:cloudprovision/models/template_model.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// TODO set it during startup in Dockerfile
// const cloudRunUrl = String.fromEnvironment('CLOUD_PROVISION_SERVICE_URL');
const cloudRunUrl = "cloud-provision-server-4mizdq5szq-ue.a.run.app";

class BuildRepository {
  Future<String?> deployTemplate(TemplateModel template) async {
    return await callCloudProvisionService(template);
  }

  Future<String?> callCloudProvisionService(TemplateModel template) async {
    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    try {
      Map<String, String> requestHeaders = {
        HttpHeaders.authorizationHeader: "Bearer " + identityToken,
      };

      var endpointPath = '/v1/builds';

      var url = Uri.https(cloudRunUrl, endpointPath);

      var response = await http.post(url,
          headers: requestHeaders, body: {"template_id": "${template.id}"});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.body;
    } catch (e) {
      print(e);
    }
  }
}
