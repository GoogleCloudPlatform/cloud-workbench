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
