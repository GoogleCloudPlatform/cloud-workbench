// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectServiceHash() => r'f6a348fa50f8a748617ad8fbcc45b0c95c281035';

/// See also [projectService].
@ProviderFor(projectService)
final projectServiceProvider = AutoDisposeProvider<ProjectService>.internal(
  projectService,
  name: r'projectServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectServiceRef = AutoDisposeProviderRef<ProjectService>;
String _$serviceStatusHash() => r'25377e77771581c17fa432d7991866eea947b7ae';

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

typedef ServiceStatusRef = AutoDisposeFutureProviderRef<bool>;

/// See also [serviceStatus].
@ProviderFor(serviceStatus)
const serviceStatusProvider = ServiceStatusFamily();

/// See also [serviceStatus].
class ServiceStatusFamily extends Family<AsyncValue<bool>> {
  /// See also [serviceStatus].
  const ServiceStatusFamily();

  /// See also [serviceStatus].
  ServiceStatusProvider call({
    required Project project,
    required String serviceName,
  }) {
    return ServiceStatusProvider(
      project: project,
      serviceName: serviceName,
    );
  }

  @override
  ServiceStatusProvider getProviderOverride(
    covariant ServiceStatusProvider provider,
  ) {
    return call(
      project: provider.project,
      serviceName: provider.serviceName,
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
  String? get name => r'serviceStatusProvider';
}

/// See also [serviceStatus].
class ServiceStatusProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [serviceStatus].
  ServiceStatusProvider({
    required this.project,
    required this.serviceName,
  }) : super.internal(
          (ref) => serviceStatus(
            ref,
            project: project,
            serviceName: serviceName,
          ),
          from: serviceStatusProvider,
          name: r'serviceStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceStatusHash,
          dependencies: ServiceStatusFamily._dependencies,
          allTransitiveDependencies:
              ServiceStatusFamily._allTransitiveDependencies,
        );

  final Project project;
  final String serviceName;

  @override
  bool operator ==(Object other) {
    return other is ServiceStatusProvider &&
        other.project == project &&
        other.serviceName == serviceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, project.hashCode);
    hash = _SystemHash.combine(hash, serviceName.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
