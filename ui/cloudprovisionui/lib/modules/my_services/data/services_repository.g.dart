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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
