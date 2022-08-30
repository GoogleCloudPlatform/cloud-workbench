import 'dart:convert';
import 'dart:io';

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
  ..options('/v1/builds', _startBuild);

final _templates = [
  {
    'id': 1,
    'name': 'Trigerring Workflows with Eventarc',
    'git':
        'https://github.com/gcp-solutions/cloud-provision-templates/workflows-eventarc'
  },
  {
    'id': 2,
    'name': 'Secure Serverless Apps with IAP',
    'git':
        'https://github.com/gcp-solutions/cloud-provision-templates/cloudrun-iap'
  },
  {
    'id': 3,
    'name': 'Triggering Cloud Functions from GCS',
    'git':
        'https://github.com/gcp-solutions/cloud-provision-templates/cloudfunctions-gcs'
  },
];

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

Response _getTemplates(Request request) {
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
    _jsonEncode(_templates),
    headers: {
      ..._jsonHeaders,
    },
  );
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

  final body = await request.readAsString();

  AuthClient client = await clientViaMetadataServer();

  var cloudBuildApi = cb.CloudBuildApi(client);

  // TODO needs to be provided by user
  var projectId = 'andrey-cp-8-9';

  String parent = "projects/${projectId}/locations/global";
  var _json = {
    "name": "bash",
    "args": [
      "echo",
      "Cloud Provision - Running a bash command for template ${body}"
    ]
  };
  var buildStep = cb.BuildStep.fromJson(_json);
  var buildRequest = cb.Build(steps: [buildStep]);
  cb.Operation buildOp = await cloudBuildApi.projects.builds
      .create(buildRequest, projectId, parent: parent);
  print(buildOp.metadata);

  return Response.ok(
    _jsonEncode(buildOp.metadata),
    headers: {
      ..._jsonHeaders,
    },
  );
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
