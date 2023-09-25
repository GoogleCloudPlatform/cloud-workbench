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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  const AuthRepository({required this.service});

  final AuthService service;

  /// Signs in with Google
  Future<void> signInWithGoogle() async => service.signInWithGoogle();

  /// Signs out the user
  Future<void> signOut() async => service.signOut();

  User? currentUser() => service.getCurrentUser();

  Stream<GoogleSignInAccount?> currentUserChanges() => service.currentUserChanges();

  Future<AuthClient?> getAuthenticatedClient() => service.getAuthenticatedClient();

  AuthClient getAuthClient() => service.getAuthClient();

  GoogleSignIn getGoogleSingIn() => service.googleSignIn();
}
