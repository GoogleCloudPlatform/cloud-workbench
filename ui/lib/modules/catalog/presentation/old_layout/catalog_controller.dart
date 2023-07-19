import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/catalog_service.dart';

part 'catalog_controller.g.dart';

@riverpod
class CatalogController extends _$CatalogController {
  @override
  FutureOr<void> build() {}

  CatalogService get catalogService => ref.read(catalogServiceProvider);

  Future<List<Template>> loadTemplates() {
    return catalogService.loadTemplates();
  }

  Future<Template> templateById() {
    return catalogService.templateById();
  }
}
