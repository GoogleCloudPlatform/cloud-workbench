import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/cloudresourcemanager/v1.dart' as crm;

class ProjectsService {
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

    AuthClient client = await clientViaMetadataServer();
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
