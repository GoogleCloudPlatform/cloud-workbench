// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_workstations_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cloudWorkstationsRepositoryHash() =>
    r'cf3b1a7f92c3fea4b51eb4b5c0ba27eb2f84da12';

/// See also [cloudWorkstationsRepository].
@ProviderFor(cloudWorkstationsRepository)
final cloudWorkstationsRepositoryProvider =
    AutoDisposeProvider<CloudWorkstationsRepository>.internal(
  cloudWorkstationsRepository,
  name: r'cloudWorkstationsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cloudWorkstationsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CloudWorkstationsRepositoryRef
    = AutoDisposeProviderRef<CloudWorkstationsRepository>;
String _$workstationsHash() => r'9a92811214509bbf4839358922f88d0b0929cb3f';

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

typedef WorkstationsRef = AutoDisposeFutureProviderRef<List<Workstation>>;

/// See also [workstations].
@ProviderFor(workstations)
const workstationsProvider = WorkstationsFamily();

/// See also [workstations].
class WorkstationsFamily extends Family<AsyncValue<List<Workstation>>> {
  /// See also [workstations].
  const WorkstationsFamily();

  /// See also [workstations].
  WorkstationsProvider call({
    required String projectId,
    required String clusterName,
    required String configName,
    required String region,
  }) {
    return WorkstationsProvider(
      projectId: projectId,
      clusterName: clusterName,
      configName: configName,
      region: region,
    );
  }

  @override
  WorkstationsProvider getProviderOverride(
    covariant WorkstationsProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      clusterName: provider.clusterName,
      configName: provider.configName,
      region: provider.region,
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
  String? get name => r'workstationsProvider';
}

/// See also [workstations].
class WorkstationsProvider
    extends AutoDisposeFutureProvider<List<Workstation>> {
  /// See also [workstations].
  WorkstationsProvider({
    required this.projectId,
    required this.clusterName,
    required this.configName,
    required this.region,
  }) : super.internal(
          (ref) => workstations(
            ref,
            projectId: projectId,
            clusterName: clusterName,
            configName: configName,
            region: region,
          ),
          from: workstationsProvider,
          name: r'workstationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workstationsHash,
          dependencies: WorkstationsFamily._dependencies,
          allTransitiveDependencies:
              WorkstationsFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String clusterName;
  final String configName;
  final String region;

  @override
  bool operator ==(Object other) {
    return other is WorkstationsProvider &&
        other.projectId == projectId &&
        other.clusterName == clusterName &&
        other.configName == configName &&
        other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, clusterName.hashCode);
    hash = _SystemHash.combine(hash, configName.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workstationClustersHash() =>
    r'd831047dec264a8732aa9ca9aa261e97c63d6f0a';
typedef WorkstationClustersRef = AutoDisposeFutureProviderRef<List<Cluster>>;

/// See also [workstationClusters].
@ProviderFor(workstationClusters)
const workstationClustersProvider = WorkstationClustersFamily();

/// See also [workstationClusters].
class WorkstationClustersFamily extends Family<AsyncValue<List<Cluster>>> {
  /// See also [workstationClusters].
  const WorkstationClustersFamily();

  /// See also [workstationClusters].
  WorkstationClustersProvider call({
    required String projectId,
    required String region,
  }) {
    return WorkstationClustersProvider(
      projectId: projectId,
      region: region,
    );
  }

  @override
  WorkstationClustersProvider getProviderOverride(
    covariant WorkstationClustersProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      region: provider.region,
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
  String? get name => r'workstationClustersProvider';
}

/// See also [workstationClusters].
class WorkstationClustersProvider
    extends AutoDisposeFutureProvider<List<Cluster>> {
  /// See also [workstationClusters].
  WorkstationClustersProvider({
    required this.projectId,
    required this.region,
  }) : super.internal(
          (ref) => workstationClusters(
            ref,
            projectId: projectId,
            region: region,
          ),
          from: workstationClustersProvider,
          name: r'workstationClustersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workstationClustersHash,
          dependencies: WorkstationClustersFamily._dependencies,
          allTransitiveDependencies:
              WorkstationClustersFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String region;

  @override
  bool operator ==(Object other) {
    return other is WorkstationClustersProvider &&
        other.projectId == projectId &&
        other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workstationConfigsHash() =>
    r'ff03da4dc458b65e074eb2d49c41b3d69f0a060a';
typedef WorkstationConfigsRef
    = AutoDisposeFutureProviderRef<List<WorkstationConfig>>;

/// See also [workstationConfigs].
@ProviderFor(workstationConfigs)
const workstationConfigsProvider = WorkstationConfigsFamily();

/// See also [workstationConfigs].
class WorkstationConfigsFamily
    extends Family<AsyncValue<List<WorkstationConfig>>> {
  /// See also [workstationConfigs].
  const WorkstationConfigsFamily();

  /// See also [workstationConfigs].
  WorkstationConfigsProvider call({
    required String projectId,
    required String region,
    required String clusterName,
  }) {
    return WorkstationConfigsProvider(
      projectId: projectId,
      region: region,
      clusterName: clusterName,
    );
  }

  @override
  WorkstationConfigsProvider getProviderOverride(
    covariant WorkstationConfigsProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      region: provider.region,
      clusterName: provider.clusterName,
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
  String? get name => r'workstationConfigsProvider';
}

/// See also [workstationConfigs].
class WorkstationConfigsProvider
    extends AutoDisposeFutureProvider<List<WorkstationConfig>> {
  /// See also [workstationConfigs].
  WorkstationConfigsProvider({
    required this.projectId,
    required this.region,
    required this.clusterName,
  }) : super.internal(
          (ref) => workstationConfigs(
            ref,
            projectId: projectId,
            region: region,
            clusterName: clusterName,
          ),
          from: workstationConfigsProvider,
          name: r'workstationConfigsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workstationConfigsHash,
          dependencies: WorkstationConfigsFamily._dependencies,
          allTransitiveDependencies:
              WorkstationConfigsFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String region;
  final String clusterName;

  @override
  bool operator ==(Object other) {
    return other is WorkstationConfigsProvider &&
        other.projectId == projectId &&
        other.region == region &&
        other.clusterName == clusterName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);
    hash = _SystemHash.combine(hash, clusterName.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$allWorkstationsHash() => r'e66875af19a30bdf09301e77f2afbabf94004660';
typedef AllWorkstationsRef = AutoDisposeFutureProviderRef<List<Workstation>>;

/// See also [allWorkstations].
@ProviderFor(allWorkstations)
const allWorkstationsProvider = AllWorkstationsFamily();

/// See also [allWorkstations].
class AllWorkstationsFamily extends Family<AsyncValue<List<Workstation>>> {
  /// See also [allWorkstations].
  const AllWorkstationsFamily();

  /// See also [allWorkstations].
  AllWorkstationsProvider call({
    required String projectId,
    required String clusterName,
    required String region,
  }) {
    return AllWorkstationsProvider(
      projectId: projectId,
      clusterName: clusterName,
      region: region,
    );
  }

  @override
  AllWorkstationsProvider getProviderOverride(
    covariant AllWorkstationsProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      clusterName: provider.clusterName,
      region: provider.region,
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
  String? get name => r'allWorkstationsProvider';
}

/// See also [allWorkstations].
class AllWorkstationsProvider
    extends AutoDisposeFutureProvider<List<Workstation>> {
  /// See also [allWorkstations].
  AllWorkstationsProvider({
    required this.projectId,
    required this.clusterName,
    required this.region,
  }) : super.internal(
          (ref) => allWorkstations(
            ref,
            projectId: projectId,
            clusterName: clusterName,
            region: region,
          ),
          from: allWorkstationsProvider,
          name: r'allWorkstationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allWorkstationsHash,
          dependencies: AllWorkstationsFamily._dependencies,
          allTransitiveDependencies:
              AllWorkstationsFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String clusterName;
  final String region;

  @override
  bool operator ==(Object other) {
    return other is AllWorkstationsProvider &&
        other.projectId == projectId &&
        other.clusterName == clusterName &&
        other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, clusterName.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$checkWorkstationsStatusStreamHash() =>
    r'7b6ba91505266d4f5d766b4a5f41a5bacbb3e5f4';
typedef CheckWorkstationsStatusStreamRef
    = AutoDisposeStreamProviderRef<List<Workstation>>;

/// See also [checkWorkstationsStatusStream].
@ProviderFor(checkWorkstationsStatusStream)
const checkWorkstationsStatusStreamProvider =
    CheckWorkstationsStatusStreamFamily();

/// See also [checkWorkstationsStatusStream].
class CheckWorkstationsStatusStreamFamily
    extends Family<AsyncValue<List<Workstation>>> {
  /// See also [checkWorkstationsStatusStream].
  const CheckWorkstationsStatusStreamFamily();

  /// See also [checkWorkstationsStatusStream].
  CheckWorkstationsStatusStreamProvider call({
    required String projectId,
    required String clusterName,
    required String configName,
    required String instanceName,
    required String region,
  }) {
    return CheckWorkstationsStatusStreamProvider(
      projectId: projectId,
      clusterName: clusterName,
      configName: configName,
      instanceName: instanceName,
      region: region,
    );
  }

  @override
  CheckWorkstationsStatusStreamProvider getProviderOverride(
    covariant CheckWorkstationsStatusStreamProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      clusterName: provider.clusterName,
      configName: provider.configName,
      instanceName: provider.instanceName,
      region: provider.region,
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
  String? get name => r'checkWorkstationsStatusStreamProvider';
}

/// See also [checkWorkstationsStatusStream].
class CheckWorkstationsStatusStreamProvider
    extends AutoDisposeStreamProvider<List<Workstation>> {
  /// See also [checkWorkstationsStatusStream].
  CheckWorkstationsStatusStreamProvider({
    required this.projectId,
    required this.clusterName,
    required this.configName,
    required this.instanceName,
    required this.region,
  }) : super.internal(
          (ref) => checkWorkstationsStatusStream(
            ref,
            projectId: projectId,
            clusterName: clusterName,
            configName: configName,
            instanceName: instanceName,
            region: region,
          ),
          from: checkWorkstationsStatusStreamProvider,
          name: r'checkWorkstationsStatusStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkWorkstationsStatusStreamHash,
          dependencies: CheckWorkstationsStatusStreamFamily._dependencies,
          allTransitiveDependencies:
              CheckWorkstationsStatusStreamFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String clusterName;
  final String configName;
  final String instanceName;
  final String region;

  @override
  bool operator ==(Object other) {
    return other is CheckWorkstationsStatusStreamProvider &&
        other.projectId == projectId &&
        other.clusterName == clusterName &&
        other.configName == configName &&
        other.instanceName == instanceName &&
        other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, clusterName.hashCode);
    hash = _SystemHash.combine(hash, configName.hashCode);
    hash = _SystemHash.combine(hash, instanceName.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$workstationStartingProgressHash() =>
    r'2d89302cb85848acff03ff5a30f92bac353bae50';
typedef WorkstationStartingProgressRef = AutoDisposeStreamProviderRef<bool>;

/// See also [workstationStartingProgress].
@ProviderFor(workstationStartingProgress)
const workstationStartingProgressProvider = WorkstationStartingProgressFamily();

/// See also [workstationStartingProgress].
class WorkstationStartingProgressFamily extends Family<AsyncValue<bool>> {
  /// See also [workstationStartingProgress].
  const WorkstationStartingProgressFamily();

  /// See also [workstationStartingProgress].
  WorkstationStartingProgressProvider call({
    required String projectId,
    required String clusterName,
    required String configName,
    required String instanceName,
    required String region,
  }) {
    return WorkstationStartingProgressProvider(
      projectId: projectId,
      clusterName: clusterName,
      configName: configName,
      instanceName: instanceName,
      region: region,
    );
  }

  @override
  WorkstationStartingProgressProvider getProviderOverride(
    covariant WorkstationStartingProgressProvider provider,
  ) {
    return call(
      projectId: provider.projectId,
      clusterName: provider.clusterName,
      configName: provider.configName,
      instanceName: provider.instanceName,
      region: provider.region,
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
  String? get name => r'workstationStartingProgressProvider';
}

/// See also [workstationStartingProgress].
class WorkstationStartingProgressProvider
    extends AutoDisposeStreamProvider<bool> {
  /// See also [workstationStartingProgress].
  WorkstationStartingProgressProvider({
    required this.projectId,
    required this.clusterName,
    required this.configName,
    required this.instanceName,
    required this.region,
  }) : super.internal(
          (ref) => workstationStartingProgress(
            ref,
            projectId: projectId,
            clusterName: clusterName,
            configName: configName,
            instanceName: instanceName,
            region: region,
          ),
          from: workstationStartingProgressProvider,
          name: r'workstationStartingProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workstationStartingProgressHash,
          dependencies: WorkstationStartingProgressFamily._dependencies,
          allTransitiveDependencies:
              WorkstationStartingProgressFamily._allTransitiveDependencies,
        );

  final String projectId;
  final String clusterName;
  final String configName;
  final String instanceName;
  final String region;

  @override
  bool operator ==(Object other) {
    return other is WorkstationStartingProgressProvider &&
        other.projectId == projectId &&
        other.clusterName == clusterName &&
        other.configName == configName &&
        other.instanceName == instanceName &&
        other.region == region;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, clusterName.hashCode);
    hash = _SystemHash.combine(hash, configName.hashCode);
    hash = _SystemHash.combine(hash, instanceName.hashCode);
    hash = _SystemHash.combine(hash, region.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
