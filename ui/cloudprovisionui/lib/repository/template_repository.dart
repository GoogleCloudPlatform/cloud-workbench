import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/repository/service/template_service.dart';

class TemplateRepository {
  const TemplateRepository({required this.service});

  final TemplateService service;

  /// Returns list of templates
  Future<List<Template>> loadTemplates() async => service.loadTemplates();

  /// Returns template by id
  ///
  /// [templateId]
  Future<Template> loadTemplateById(int templateId) async =>
      service.loadTemplateById(templateId);

  Future<void> forkRepository(
          String sourceRepo, String token, String targetRepoName) async =>
      service.forkRepository(sourceRepo, token, targetRepoName);
}
