import 'package:cloudprovision/repository/models/template.dart';
import 'package:cloudprovision/repository/service/template_service.dart';

class TemplateRepository {
  const TemplateRepository({required this.service});

  final TemplateService service;

  /// Returns list of templates
  Future<List<Template>> loadTemplates(
          String catalogSource, String catalogUrl) async =>
      service.loadTemplates(catalogSource, catalogUrl);

  /// Returns template by id
  ///
  /// [templateId]
  Future<Template> loadTemplateById(
          int templateId, String catalogSource) async =>
      service.loadTemplateById(templateId, catalogSource);
}
