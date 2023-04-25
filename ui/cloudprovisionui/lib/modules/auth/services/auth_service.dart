import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../repository/service/base_service.dart';

class AuthService extends BaseService {
  final _firebaseAuth = FirebaseAuth.instance;

  // Set CLIENT_ID value in assets/.env
  // example: CLIENT_ID="Client ID value from the GCP Auth Credentials"
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get('CLIENT_ID'),
    scopes: <String>[],
  );

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;
      if (await _googleSignIn.isSignedIn()) {
        googleUser = await _googleSignIn.signInSilently();
      } else {
        googleUser = await _googleSignIn.signIn();
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

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
}
