import 'dart:convert';
import 'dart:io';

import 'package:cloud_provision_server/models/template_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:uuid/uuid.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/cloudbuild/v1.dart' as cb;
import 'package:googleapis/cloudresourcemanager/v1.dart' as crm;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final cascade = Cascade().add(_router);

  final server = await shelf_io.serve(
    logRequests().addHandler(cascade.handler),
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}

final _router = shelf_router.Router()
  ..get('/test', _test)
  ..options('/test', _test)
  ..get('/v1/templates', _getTemplates)
  ..options('/v1/templates', _getTemplates)
  ..get('/v1/projects', _getProjects)
  ..options('/v1/projects', _getProjects)
  ..get('/v1/templates', _getTemplates)
  ..options('/v1/templates', _getTemplates)
  ..post('/v1/builds', _startBuild)
  ..options('/v1/builds', _startBuild)
  ..get('/v1/builds', _getBuild)
  ..post('/v1/triggers', _runTrigger)
  ..options('/v1/triggers', _runTrigger);

bool isValidToken(Request request) {
  if (request.method == "OPTIONS") {
    return true;
  }

  if (request.headers[HttpHeaders.authorizationHeader] != null) {
    try {
      String? authorization = request.headers[HttpHeaders.authorizationHeader];
      List<String> tokens = authorization!.split(" ");
      if (tokens.length != 2 || tokens[0] != "Bearer") {
        return false;
      }

      var token = tokens[1];

      if (JwtDecoder.isExpired(token)) {
        print("Expired token");
        return false;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // if (decodedToken["iss"] != "accounts.google.com") {
      //   print("Invalid iss - ${decodedToken["iss"]}");
      //   return false;
      // }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
  print("401 Unauthorized");
  return false;
}

Response _test(Request request) {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  return Response.ok(
    _jsonEncode({"msg": "OK"}),
    headers: {
      ..._jsonHeaders,
    },
  );
}

Response _handleOptions(Request request) {
  return Response.ok(
    null,
    headers: {
      ..._jsonHeaders,
    },
  );
}

Future<Response> _getTemplates(Request request) async {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  return Response.ok(
    _jsonEncode(await _fetchTemplates()),
    headers: {
      ..._jsonHeaders,
    },
  );
}

Future<List<TemplateModel>> _fetchTemplates() async {
  final http.Client client = new http.Client();
  var response = await client.get(Uri.parse(
      "https://raw.githubusercontent.com/gitrey/cp-templates/main/templates.json"));

  Iterable templateList = json.decode(response.body);
  List<TemplateModel> templates = List<TemplateModel>.from(
      templateList.map((model) => TemplateModel.fromJson(model)));

  return templates;
}

Future<Map<String, dynamic>> _fetchCloudProvisionConfig(
    String cloudProvisionConfigUrl) async {
  final http.Client client = new http.Client();
  var response = await client.get(Uri.parse(cloudProvisionConfigUrl));
  return json.decode(response.body);
}

// var uuid = Uuid();

Future<Response> _startBuild(Request request) async {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  try {
    final body = await request.readAsString();
    Map<String, dynamic> requestMap = jsonDecode(body);

    List<TemplateModel> templates = await _fetchTemplates();
    var templatesMap =
        Map.fromIterable(templates, key: (t) => t.id, value: (t) => t);

    TemplateModel? template =
        templatesMap[int.parse(requestMap['template_id'])];

    Map<String, dynamic> jsonConfig =
        await _fetchCloudProvisionConfig(template!.cloudProvisionConfigUrl);

    var projectId = requestMap['project_id'];
    String parent = "projects/${projectId}/locations/global";

    Map<String, String> m = Map<String, String>.from(requestMap['params']);

    // Map<String, String> substitutions = jsonDecode(requestMap['params']);

    AuthClient client = await clientViaMetadataServer();
    var cloudBuildApi = cb.CloudBuildApi(client);

    var buildStep = cb.BuildStep.fromJson(jsonConfig);
    var buildRequest = cb.Build(substitutions: m, steps: [buildStep]);
    cb.Operation buildOp = await cloudBuildApi.projects.builds
        .create(buildRequest, projectId, parent: parent);

    var list = await cloudBuildApi.projects.triggers.list(projectId);

    return Response.ok(
      _jsonEncode(buildOp.metadata),
      headers: {
        ..._jsonHeaders,
      },
    );
  } on Exception catch (e) {
    print(e);
    return Response.internalServerError(
      body: _jsonEncode({"msg": "Internal Server Error"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }
}

Future<Response> _getProjects(Request request) async {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  String userIdentityToken = _getUserIdentityToken(request);

  return Response.ok(
    _jsonEncode(await _getUserProjects(userIdentityToken)),
    headers: {
      ..._jsonHeaders,
    },
  );
}

String _getUserIdentityToken(Request request) {
  String userIdentityToken = "";

  String? authorization = request.headers[HttpHeaders.authorizationHeader];
  List<String> tokens = authorization!.split(" ");
  if (tokens.length != 2 || tokens[0] != "Bearer") {
    return userIdentityToken;
  }

  userIdentityToken = authorization;

  return userIdentityToken;
}

Future<List<String?>> _getUserProjects(String userIdentityToken) async {
  // TODO
  //  - needs to be user projects' specific list
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
    print(project.name);
    projectList.add(project.name);
  }

  return projectList;
}

String _jsonEncode(Object? data) =>
    const JsonEncoder.withIndent(' ').convert(data);

const _jsonHeaders = {
  'content-type': 'application/json',
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
      'Content-Type, Authorization, Access-Control-Allow-Origin, Access-Control-Allow-Methods',
  'Access-Control-Allow-Methods': 'OPTIONS,HEAD,GET,PUT,POST,DELETE',
};

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

Future<Response> _getBuild(Request request) async {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  String? projectId = request.url.queryParameters['projectId'];
  String? buildId = request.url.queryParameters['buildId'];

  return Response.ok(
    _jsonEncode(await _getBuildDetails(projectId, buildId)),
    headers: {
      ..._jsonHeaders,
    },
  );
}

Future<cb.Build> _getBuildDetails(projectId, buildId) async {
  AuthClient client = await clientViaMetadataServer();
  var cloudBuildApi = cb.CloudBuildApi(client);

  cb.Build build = await cloudBuildApi.projects.builds.get(projectId, buildId);
  print(build);
  print(build.status);

  return build;
}

Future<Response> _runTrigger(Request request) async {
  if (request.method == "OPTIONS") {
    return _handleOptions(request);
  }

  if (!isValidToken(request)) {
    return Response.forbidden(
      _jsonEncode({"msg": "Forbidden"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }

  try {
    final body = await request.readAsString();
    Map<String, dynamic> requestMap = jsonDecode(body);

    var projectId = requestMap['project_id'];
    var branchName = "main";

    AuthClient client = await clientViaMetadataServer();
    var cloudBuildApi = cb.CloudBuildApi(client);

    var list = await cloudBuildApi.projects.triggers.list(projectId);
    late cb.BuildTrigger buildTrigger;
    bool foundTrigger = false;

    list.triggers!.forEach((trigger) {
      if (trigger.name == requestMap['app_name'] + "-trigger") {
        buildTrigger = trigger;
        foundTrigger = true;
      }
    });

    if (foundTrigger) {
      String? triggerId = buildTrigger.id;
      String? triggerName =
          "projects/${projectId}/locations/global/triggers/${buildTrigger.name}";

      cb.RepoSource repoSource = cb.RepoSource(branchName: branchName);
      cb.RunBuildTriggerRequest rbtr = cb.RunBuildTriggerRequest(
          source: repoSource, projectId: projectId, triggerId: triggerId);

      var operation = await cloudBuildApi.projects.locations.triggers
          .run(rbtr, triggerName!);

      return Response.ok(
        _jsonEncode(operation.metadata),
        headers: {
          ..._jsonHeaders,
        },
      );
    }

    return Response.internalServerError(
      body: _jsonEncode({"msg": "Failed to run trigger"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  } on Exception catch (e) {
    print(e);
    return Response.internalServerError(
      body: _jsonEncode({"msg": "Internal Server Error"}),
      headers: {
        ..._jsonHeaders,
      },
    );
  }
}
