import 'package:cloud_provision_server/controllers/EnvController.dart';
import 'package:cloud_provision_server/controllers/SecurityController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'BuildsController.dart';
import 'ProjectsController.dart';
import 'TemplatesController.dart';
import 'TriggersController.dart';
import 'WorkstationsController.dart';

class ServerController {
  EnvController _envController = EnvController();
  TemplatesController _templatesController = TemplatesController();
  ProjectsController _projectsController = ProjectsController();
  BuildsController _buildsController = BuildsController();
  TriggersController _triggersController = TriggersController();
  SecurityController _securityController = SecurityController();
  WorkstationsController _workstationsController = WorkstationsController();

  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
      return Response.ok('Cloud Provision API');
    });
    router.mount('/v1/env', _envController.router);
    router.mount('/v1/templates', _templatesController.router);
    router.mount('/v1/projects', _projectsController.router);
    router.mount('/v1/builds', _buildsController.router);
    router.mount('/v1/triggers', _triggersController.router);
    router.mount('/v1/security', _securityController.router);
    router.mount('/v1/workstationClusters', _workstationsController.router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Not found');
    });

    return router;
  }
}
