// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:cloud_provision_shared/catalog/models/param.dart';
import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'ConfigService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TemplatesService {

  ConfigService _configService = ConfigService();

  String? getEnvVar(String varName) {
    return dotenv.get(varName);
  }

  String _getCatalogUrl({String catalogSource = "gcp"}) {
    var catalogUrl = getEnvVar("GCP_CATALOG_URL")!;
    if (catalogSource == "community") {
      catalogUrl = getEnvVar("COMMUNITY_CATALOG_URL")!;
    } else if (catalogSource == "customer") {
      catalogUrl = "";
    }
    return catalogUrl;
  }

  /// Returns list of solution templates
  Future<List<Template>> getTemplates() async {
    final http.Client client = new http.Client();

    var catalogUrl = _getCatalogUrl();

    var response = await client.get(Uri.parse(catalogUrl));

    Iterable templateList = json.decode(response.body);
    List<Template> templates = List<Template>.from(
        templateList.map((model) => Template.fromJson(model)));

    return templates;
  }

  Future<Template?> getTemplateById(
      int templateId, String catalogSource) async {
    final http.Client client = new http.Client();

    // TODO: add logic to handle private catalog
    if (catalogSource == "customer") {
      return null;
    }

    var catalogUrl = _getCatalogUrl(catalogSource: catalogSource);

    var response = await client.get(Uri.parse(catalogUrl));

    Iterable templateList = json.decode(response.body);
    List<Template> templates = List<Template>.from(
        templateList.map((model) => Template.fromJson(model)));

    List<Template> templateL =
        templates.where((element) => element.id == templateId).toList();

    Template template;
    if (templateL.isEmpty) {
      return null;
    }
    template = templateL.first;

    Map<String, dynamic> cloudProvisionJsonConfig =
        await _configService.getJson(template.cloudProvisionConfigUrl);

    Iterable paramsList = cloudProvisionJsonConfig['inputs'];
    List<Param> params =
        List<Param>.from(paramsList.map((model) => Param.fromJson(model)));

    template.inputs = params;

    return template;
  }
}
