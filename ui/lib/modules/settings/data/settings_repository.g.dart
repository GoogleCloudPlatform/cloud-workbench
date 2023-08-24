// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gitSettingsHash() => r'15fa5690e55ece79d8264f7d3f7557106a795d7e';

/// See also [gitSettings].
@ProviderFor(gitSettings)
final gitSettingsProvider = AutoDisposeFutureProvider<GitSettings>.internal(
  gitSettings,
  name: r'gitSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gitSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GitSettingsRef = AutoDisposeFutureProviderRef<GitSettings>;
String _$settingsRepositoryHash() =>
    r'e05ceb12b68afa315d5fac434e3f45771112f351';

/// See also [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
  settingsRepository,
  name: r'settingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
