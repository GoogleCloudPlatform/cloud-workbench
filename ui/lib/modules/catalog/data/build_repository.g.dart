// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buildRepositoryHash() => r'cd217643b8d0a1d1d7607b37fc3ab3a9ec5b0818';

/// See also [buildRepository].
@ProviderFor(buildRepository)
final buildRepositoryProvider = AutoDisposeProvider<BuildRepository>.internal(
  buildRepository,
  name: r'buildRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$buildRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BuildRepositoryRef = AutoDisposeProviderRef<BuildRepository>;
String _$triggerBuildsHash() => r'b7ab9f94f7eb305fb555f8877af7c16d0711312a';

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

typedef TriggerBuildsRef = AutoDisposeFutureProviderRef<List<Build>>;

/// See also [triggerBuilds].
@ProviderFor(triggerBuilds)
const triggerBuildsProvider = TriggerBuildsFamily();

/// See also [triggerBuilds].
class TriggerBuildsFamily extends Family<AsyncValue<List<Build>>> {
  /// See also [triggerBuilds].
  const TriggerBuildsFamily();

  /// See also [triggerBuilds].
  TriggerBuildsProvider call({
    required String projectId,
    required String serviceId,
  }) {
    return TriggerBuildsProvider(
      projectId: projectId,
      serviceId: serviceId,
    );
  }

  @override
  TriggerBuildsProvider getProviderOverride(
    covariant TriggerBuildsProvider provider,
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
  String? get name => r'triggerBuildsProvider';
}

/// See also [triggerBuilds].
class TriggerBuildsProvider extends AutoDisposeFutureProvider<List<Build>> {
  /// See also [triggerBuilds].
  TriggerBuildsProvider({
    required this.projectId,
    required this.serviceId,
  }) : super.internal(
          (ref) => triggerBuilds(
            ref,
            projectId: projectId,
            serviceId: serviceId,
          ),
          from: triggerBuildsProvider,
          name: r'triggerBuildsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$triggerBuildsHash,
          dependencies: TriggerBuildsFamily._dependencies,
          allTransitiveDependencies:
              TriggerBuildsFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String serviceId;

  @override
  bool operator ==(Object other) {
    return other is TriggerBuildsProvider &&
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
