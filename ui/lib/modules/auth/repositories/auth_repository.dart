import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  const AuthRepository({required this.service});

  final AuthService service;

  /// Signs in with Google
  Future<void> signInWithGoogle() async => service.signInWithGoogle();

  /// Signs out the user
  Future<void> signOut() async => service.signOut();

  User? currentUser() => service.getCurrentUser();
}
