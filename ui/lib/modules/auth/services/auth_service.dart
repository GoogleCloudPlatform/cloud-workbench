import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import '../../../shared/service/base_service.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';


class AuthService extends BaseService {

  final _firebaseAuth = FirebaseAuth.instance;

  // Set CLIENT_ID value in assets/.env
  // example: CLIENT_ID="Client ID value from the GCP Auth Credentials"
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get('CLIENT_ID'),
    scopes: <String>[
      "https://www.googleapis.com/auth/cloud-platform",
    ],
  );



  late GoogleSignInAccount? googleUser;
  late GoogleSignInAuthentication? googleAuth;
  late AuthClient? authClient;

  Future<void> signInWithGoogle() async {
    try {

      if (await _googleSignIn.isSignedIn()) {
        googleUser = await _googleSignIn.signInSilently();
      } else {
        googleUser = await _googleSignIn.signIn();
      }

      googleAuth = await googleUser?.authentication;

      authClient = await _googleSignIn.authenticatedClient();

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<GoogleSignInAccount?> currentUserChanges() {
    return _googleSignIn.onCurrentUserChanged;
  }

  Future<AuthClient?> getAuthenticatedClient() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    return httpClient;
  }

  AuthClient getAuthClient() {
    return authClient!;
  }

  GoogleSignIn googleSignIn() {
    return _googleSignIn;
  }
}
