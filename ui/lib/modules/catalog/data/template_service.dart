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
import 'package:http/http.dart' as http;

import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:cloud_provision_shared/services/TemplatesService.dart' as sharedService;
import '../../../shared/service/base_service.dart';

class TemplateService extends BaseService {

  Future<List<Template>> loadTemplates() async {

    List<Template> templates = [];

    if (serverEnabled) {
      var endpointPath = '/v1/templates';

      final queryParameters = {
        'catalogSource': 'catalogSource',
        'catalogUrl': 'catalogUrl',
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      Map<String, String> requestHeaders = await getRequestHeaders();

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      Iterable l = json.decode(response.body);

      templates = List<Template>
          .from(l.map((model) => Template.fromJson(model)));
    } else {
      sharedService.TemplatesService templatesService = new sharedService
          .TemplatesService();
      templates = await templatesService.getTemplates();
    }

    return templates;
  }

  Future<Template> loadTemplateById(
      int templateId, String catalogSource) async {

    Template? template;

    if (serverEnabled) {
      var endpointPath = '/v1/templates';
      final queryParameters = {
        'templateId': templateId.toString(),
        'catalogSource': catalogSource,
      };

      var url = getUrl(endpointPath, queryParameters: queryParameters);

      Map<String, String> requestHeaders = await getRequestHeaders();

      var response = await http
          .get(url, headers: requestHeaders)
          .timeout(Duration(seconds: 10));

      template = Template.fromJson(json.decode(response.body));
    } else {
      sharedService.TemplatesService templatesService = new sharedService
          .TemplatesService();
      template = await templatesService.getTemplateById(templateId, catalogSource);
    }

    return template!;
  }
}
