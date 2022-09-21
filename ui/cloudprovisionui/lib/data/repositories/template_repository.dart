import 'dart:convert';
import 'dart:io';

import 'package:cloudprovision/models/template_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

var cloudRunUrl = dotenv.get('CLOUD_PROVISION_API_URL');

class TemplateRepository {
  Future<List<TemplateModel>> loadTemplates(BuildContext context) async {
    var endpointPath = '/v1/templates';
    var url = Uri.https(cloudRunUrl, endpointPath);

    final user = FirebaseAuth.instance.currentUser!;
    var identityToken = await user.getIdToken();

    Map<String, String> requestHeaders = {
      HttpHeaders.authorizationHeader: "Bearer " + identityToken,
    };

    var response = await http.get(url, headers: requestHeaders);

    Iterable l = json.decode(response.body);
    List<TemplateModel> templates = List<TemplateModel>.from(
        l.map((model) => TemplateModel.fromJson(model)));

    return templates;
  }
}
