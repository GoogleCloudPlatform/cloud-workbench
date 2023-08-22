// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authHash() => r'fa3dd035263c0602efb565e0478cdfc67e937295';

/// See also [auth].
@ProviderFor(auth)
final authProvider = AutoDisposeStreamProvider<User?>.internal(
  auth,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRef = AutoDisposeStreamProviderRef<User?>;
String _$authRepositoryHash() => r'7c548718d00e79893f61ef25833fdb4f4172f583';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$authServiceHash() => r'ac84fbd62ce222815ab95ba0aeeb9a7560d010d7';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = Provider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthServiceRef = ProviderRef<AuthService>;
String _$googleAuthHash() => r'80e8b28e837b5023e00f74c06301c640b4f78723';

/// See also [googleAuth].
@ProviderFor(googleAuth)
final googleAuthProvider =
    AutoDisposeStreamProvider<GoogleSignInAccount?>.internal(
  googleAuth,
  name: r'googleAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$googleAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GoogleAuthRef = AutoDisposeStreamProviderRef<GoogleSignInAccount?>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
