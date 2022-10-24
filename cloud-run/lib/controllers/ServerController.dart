import 'package:cloud_provision_server/controllers/SecurityController.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

import 'BuildsController.dart';
import 'ProjectsController.dart';
import 'TemplatesController.dart';
import 'TriggersController.dart';

class ServerController {
  TemplatesController _templatesController = TemplatesController();
  ProjectsController _projectsController = ProjectsController();
  BuildsController _buildsController = BuildsController();
  TriggersController _triggersController = TriggersController();
  SecurityController _securityController = SecurityController();

  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
      return Response.ok('Cloud Provision API');
    });

    router.mount('/v1/templates', _templatesController.router);
    router.mount('/v1/projects', _projectsController.router);
    router.mount('/v1/builds', _buildsController.router);
    router.mount('/v1/triggers', _triggersController.router);
    router.mount('/v1/security', _securityController.router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Not found');
    });

    return router;
  }
}
