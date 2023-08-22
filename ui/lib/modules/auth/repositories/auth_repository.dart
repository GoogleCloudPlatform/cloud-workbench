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
}
