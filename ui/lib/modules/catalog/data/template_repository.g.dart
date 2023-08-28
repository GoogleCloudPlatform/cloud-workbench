// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$templatesHash() => r'fec8fb3b7b75307b5529370dcecd83a1b350af42';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef TemplatesRef = AutoDisposeFutureProviderRef<List<Template>>;

/// See also [templates].
@ProviderFor(templates)
const templatesProvider = TemplatesFamily();

/// See also [templates].
class TemplatesFamily extends Family<AsyncValue<List<Template>>> {
  /// See also [templates].
  const TemplatesFamily();

  /// See also [templates].
  TemplatesProvider call(
    String catalogSource,
    String catalogUrl,
  ) {
    return TemplatesProvider(
      catalogSource,
      catalogUrl,
    );
  }

  @override
  TemplatesProvider getProviderOverride(
    covariant TemplatesProvider provider,
  ) {
    return call(
      provider.catalogSource,
      provider.catalogUrl,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templatesProvider';
}

/// See also [templates].
class TemplatesProvider extends AutoDisposeFutureProvider<List<Template>> {
  /// See also [templates].
  TemplatesProvider(
    this.catalogSource,
    this.catalogUrl,
  ) : super.internal(
          (ref) => templates(
            ref,
            catalogSource,
            catalogUrl,
          ),
          from: templatesProvider,
          name: r'templatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templatesHash,
          dependencies: TemplatesFamily._dependencies,
          allTransitiveDependencies: TemplatesFamily._allTransitiveDependencies,
        );

  final String catalogSource;
  final String catalogUrl;

  @override
  bool operator ==(Object other) {
    return other is TemplatesProvider &&
        other.catalogSource == catalogSource &&
        other.catalogUrl == catalogUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, catalogSource.hashCode);
    hash = _SystemHash.combine(hash, catalogUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$templateByIdHash() => r'ab40cd8726cbfbba0f51afd257aa235420701a34';
typedef TemplateByIdRef = AutoDisposeFutureProviderRef<Template>;

/// See also [templateById].
@ProviderFor(templateById)
const templateByIdProvider = TemplateByIdFamily();

/// See also [templateById].
class TemplateByIdFamily extends Family<AsyncValue<Template>> {
  /// See also [templateById].
  const TemplateByIdFamily();

  /// See also [templateById].
  TemplateByIdProvider call(
    int templateId,
    String catalogSource,
  ) {
    return TemplateByIdProvider(
      templateId,
      catalogSource,
    );
  }

  @override
  TemplateByIdProvider getProviderOverride(
    covariant TemplateByIdProvider provider,
  ) {
    return call(
      provider.templateId,
      provider.catalogSource,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templateByIdProvider';
}

/// See also [templateById].
class TemplateByIdProvider extends AutoDisposeFutureProvider<Template> {
  /// See also [templateById].
  TemplateByIdProvider(
    this.templateId,
    this.catalogSource,
  ) : super.internal(
          (ref) => templateById(
            ref,
            templateId,
            catalogSource,
          ),
          from: templateByIdProvider,
          name: r'templateByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templateByIdHash,
          dependencies: TemplateByIdFamily._dependencies,
          allTransitiveDependencies:
              TemplateByIdFamily._allTransitiveDependencies,
        );

  final int templateId;
  final String catalogSource;

  @override
  bool operator ==(Object other) {
    return other is TemplateByIdProvider &&
        other.templateId == templateId &&
        other.catalogSource == catalogSource;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, templateId.hashCode);
    hash = _SystemHash.combine(hash, catalogSource.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$templateRepositoryHash() =>
    r'4c735a486eb465a1669d182d659cd900435dd712';

/// See also [templateRepository].
@ProviderFor(templateRepository)
final templateRepositoryProvider =
    AutoDisposeProvider<TemplateRepository>.internal(
  templateRepository,
  name: r'templateRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TemplateRepositoryRef = AutoDisposeProviderRef<TemplateRepository>;
String _$tagsHash() => r'd25653d3c9421b82a976901d60896b7c52e3f9c9';

/// See also [Tags].
@ProviderFor(Tags)
final tagsProvider = AutoDisposeNotifierProvider<Tags, List<String>>.internal(
  Tags.new,
  name: r'tagsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tags = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
