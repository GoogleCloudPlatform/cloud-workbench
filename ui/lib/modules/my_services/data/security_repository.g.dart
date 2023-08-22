// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$securityRepositoryHash() =>
    r'5527aa501ee8aca21c15dcd917638cdf242ba3a3';

/// See also [securityRepository].
@ProviderFor(securityRepository)
final securityRepositoryProvider =
    AutoDisposeProvider<SecurityRepository>.internal(
  securityRepository,
  name: r'securityRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$securityRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SecurityRepositoryRef = AutoDisposeProviderRef<SecurityRepository>;
String _$containerVulnerabilitiesHash() =>
    r'712d7a85c0ae3e36d6aff19dd7c9e2cb532bd1e5';

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

typedef ContainerVulnerabilitiesRef
    = AutoDisposeFutureProviderRef<List<Vulnerability>>;

/// See also [containerVulnerabilities].
@ProviderFor(containerVulnerabilities)
const containerVulnerabilitiesProvider = ContainerVulnerabilitiesFamily();

/// See also [containerVulnerabilities].
class ContainerVulnerabilitiesFamily
    extends Family<AsyncValue<List<Vulnerability>>> {
  /// See also [containerVulnerabilities].
  const ContainerVulnerabilitiesFamily();

  /// See also [containerVulnerabilities].
  ContainerVulnerabilitiesProvider call({
    required String projectId,
    required String serviceId,
  }) {
    return ContainerVulnerabilitiesProvider(
      projectId: projectId,
      serviceId: serviceId,
    );
  }

  @override
  ContainerVulnerabilitiesProvider getProviderOverride(
    covariant ContainerVulnerabilitiesProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      serviceId: provider.serviceId,
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
  String? get name => r'containerVulnerabilitiesProvider';
}

/// See also [containerVulnerabilities].
class ContainerVulnerabilitiesProvider
    extends AutoDisposeFutureProvider<List<Vulnerability>> {
  /// See also [containerVulnerabilities].
  ContainerVulnerabilitiesProvider({
    required this.projectId,
    required this.serviceId,
  }) : super.internal(
          (ref) => containerVulnerabilities(
            ref,
            projectId: projectId,
            serviceId: serviceId,
          ),
          from: containerVulnerabilitiesProvider,
          name: r'containerVulnerabilitiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$containerVulnerabilitiesHash,
          dependencies: ContainerVulnerabilitiesFamily._dependencies,
          allTransitiveDependencies:
              ContainerVulnerabilitiesFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String serviceId;

  @override
  bool operator ==(Object other) {
    return other is ContainerVulnerabilitiesProvider &&
        other.projectId == projectId &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$securityRecommendationsHash() =>
    r'5b90d8a1f49dc626c320688f74b1703e1600e6aa';
typedef SecurityRecommendationsRef
    = AutoDisposeFutureProviderRef<List<RecommendationInsight>>;

/// See also [securityRecommendations].
@ProviderFor(securityRecommendations)
const securityRecommendationsProvider = SecurityRecommendationsFamily();

/// See also [securityRecommendations].
class SecurityRecommendationsFamily
    extends Family<AsyncValue<List<RecommendationInsight>>> {
  /// See also [securityRecommendations].
  const SecurityRecommendationsFamily();

  /// See also [securityRecommendations].
  SecurityRecommendationsProvider call({
    required String projectId,
    required String region,
    required String serviceId,
  }) {
    return SecurityRecommendationsProvider(
      projectId: projectId,
      region: region,
      serviceId: serviceId,
    );
  }

  @override
  SecurityRecommendationsProvider getProviderOverride(
    covariant SecurityRecommendationsProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      region: provider.region,
      serviceId: provider.serviceId,
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
  String? get name => r'securityRecommendationsProvider';
}

/// See also [securityRecommendations].
class SecurityRecommendationsProvider
    extends AutoDisposeFutureProvider<List<RecommendationInsight>> {
  /// See also [securityRecommendations].
  SecurityRecommendationsProvider({
    required this.projectId,
    required this.region,
    required this.serviceId,
  }) : super.internal(
          (ref) => securityRecommendations(
            ref,
            projectId: projectId,
            region: region,
            serviceId: serviceId,
          ),
          from: securityRecommendationsProvider,
          name: r'securityRecommendationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$securityRecommendationsHash,
          dependencies: SecurityRecommendationsFamily._dependencies,
          allTransitiveDependencies:
              SecurityRecommendationsFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String region;
  final String serviceId;

  @override
  bool operator ==(Object other) {
    return other is SecurityRecommendationsProvider &&
        other.projectId == projectId &&
        other.region == region &&
        other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
