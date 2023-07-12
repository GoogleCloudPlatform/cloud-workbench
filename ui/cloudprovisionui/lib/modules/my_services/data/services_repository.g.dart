// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servicesRepositoryHash() =>
    r'67df3c0745973c85de829d5d7527dd373f9b6311';

/// See also [servicesRepository].
@ProviderFor(servicesRepository)
final servicesRepositoryProvider =
    AutoDisposeProvider<ServicesRepository>.internal(
  servicesRepository,
  name: r'servicesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$servicesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ServicesRepositoryRef = AutoDisposeProviderRef<ServicesRepository>;
String _$servicesHash() => r'c887872b5c3b35d7d5bcae46941a7d6d9bd27f23';

/// See also [services].
@ProviderFor(services)
final servicesProvider = AutoDisposeFutureProvider<List<Service>>.internal(
  services,
  name: r'servicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$servicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ServicesRef = AutoDisposeFutureProviderRef<List<Service>>;
String _$serviceByDocIdHash() => r'dbd70f2125103d77236c745baf3459875affc235';

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

typedef ServiceByDocIdRef = AutoDisposeFutureProviderRef<Service>;

/// See also [serviceByDocId].
@ProviderFor(serviceByDocId)
const serviceByDocIdProvider = ServiceByDocIdFamily();

/// See also [serviceByDocId].
class ServiceByDocIdFamily extends Family<AsyncValue<Service>> {
  /// See also [serviceByDocId].
  const ServiceByDocIdFamily();

  /// See also [serviceByDocId].
  ServiceByDocIdProvider call(
    String serviceDocId,
  ) {
    return ServiceByDocIdProvider(
      serviceDocId,
    );
  }

  @override
  ServiceByDocIdProvider getProviderOverride(
    covariant ServiceByDocIdProvider provider,
  ) {
    return call(
      provider.serviceDocId,
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
  String? get name => r'serviceByDocIdProvider';
}

/// See also [serviceByDocId].
class ServiceByDocIdProvider extends AutoDisposeFutureProvider<Service> {
  /// See also [serviceByDocId].
  ServiceByDocIdProvider(
    this.serviceDocId,
  ) : super.internal(
          (ref) => serviceByDocId(
            ref,
            serviceDocId,
          ),
          from: serviceByDocIdProvider,
          name: r'serviceByDocIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceByDocIdHash,
          dependencies: ServiceByDocIdFamily._dependencies,
          allTransitiveDependencies:
              ServiceByDocIdFamily._allTransitiveDependencies,
        );

  final String serviceDocId;

  @override
  bool operator ==(Object other) {
    return other is ServiceByDocIdProvider &&
        other.serviceDocId == serviceDocId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceDocId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
