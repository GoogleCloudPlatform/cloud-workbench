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

import 'template_metadata.dart';
import 'param.dart';


class Template {
  int id;
  String name;
  String description;
  String sourceUrl;
  String cloudProvisionConfigUrl;
  String version;
  String category;
  DateTime lastModified;
  String owner;
  String email;
  bool draft;
  List<String> tags;
  List<Param> inputs;
  List<TemplateMetadata> metadata;

  Template(
      this.id,
      this.name,
      this.description,
      this.sourceUrl,
      this.cloudProvisionConfigUrl,
      this.inputs,
      this.version,
      this.category,
      this.tags,
      this.lastModified,
      this.owner,
      this.email,
      this.draft,
      this.metadata);

  Template.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        name = parsedJson['name'],
        description = parsedJson['description'],
        sourceUrl = parsedJson['sourceUrl'],
        cloudProvisionConfigUrl = parsedJson['cloudProvisionConfigUrl'],
        version = parsedJson['version'],
        category = parsedJson['category'],
        lastModified = DateTime.parse(parsedJson['lastModified'] as String),
        owner = parsedJson['owner'],
        email = parsedJson['email'],
        draft = parsedJson['draft'] == null ? true : parsedJson['draft'],
        tags = (parsedJson['tags'] as List<dynamic>).cast<String>(),
        inputs = parsedJson['inputs'] == null
            ? []
            : (parsedJson['inputs'] as List)
                .map((i) => Param.fromJson(i))
                .toList(),
        metadata = parsedJson['metadata'] == null
            ? []
            : (parsedJson['metadata'] as List)
                .map((i) => TemplateMetadata.fromJson(i))
                .toList();

  Map<String, dynamic> toJson() {
    List<Map>? tmpInputs = this.inputs != null
        ? this.inputs.map((i) => i.toJson()).toList()
        : null;

    List<Map>? tmpMetadata = this.metadata != null
        ? this.metadata.map((i) => i.toJson()).toList()
        : null;

    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceUrl': sourceUrl,
      'cloudProvisionConfigUrl': cloudProvisionConfigUrl,
      'version': version,
      'category': category,
      'lastModified': lastModified.toIso8601String(),
      'owner': owner,
      'email': email,
      'draft': draft,
      'tags': tags,
      'inputs': tmpInputs,
      'metadata': tmpMetadata,
    };
  }
}
