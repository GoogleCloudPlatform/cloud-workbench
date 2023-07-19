import 'package:cloud_provision_shared/catalog/models/template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_service.g.dart';

class CatalogService {
  CatalogService(this.ref);
  final Ref ref;

  Future<List<Template>> loadTemplates() {
    return Future.value(null);
  }

  Future<Template> templateById() {
    return Future.value(null);
  }
}

@riverpod
CatalogService catalogService(CatalogServiceRef ref) {
  return CatalogService(ref);
}