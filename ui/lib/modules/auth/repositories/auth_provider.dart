import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/auth_service.dart';
import 'auth_repository.dart';

part 'auth_provider.g.dart';


@riverpod
Stream<User?> auth(AuthRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(service: ref.read(authServiceProvider));
}

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  var service = AuthService();
  return service;
}

@riverpod
Stream<GoogleSignInAccount?> googleAuth(GoogleAuthRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.currentUserChanges();
}
