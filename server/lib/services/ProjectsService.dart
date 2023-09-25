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

import 'package:cloud_provision_server/services/BaseService.dart';
import 'package:googleapis/cloudresourcemanager/v1.dart' as crm;

class ProjectsService extends BaseService {
  /// Returns list of ACTIVE projects for provided user
  ///
  /// [userIdentityToken]
  Future<List<String?>> getUserProjects(String userIdentityToken) async {
    // TODO
    //  - needs to be user specific list of projects
    // - add Project model vs String as return type

    // Map<String, String> authHeaders = {
    //   HttpHeaders.authorizationHeader: userIdentityToken,
    // };
    //
    // final client = GoogleAuthClient(authHeaders);

    final response = await crm.CloudResourceManagerApi(client).projects.list();

    var projects = response.projects
        ?.toList()
        .where((element) => element.lifecycleState == 'ACTIVE');

    List<String?> projectList = [];
    for (final project in projects!) {
      projectList.add(project.name);
    }

    return projectList;
  }
}
