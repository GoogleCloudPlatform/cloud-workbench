import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}