import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  // Set CLIENT_ID value in assets/.env
  // example: CLIENT_ID="Client ID value from the GCP Auth Credentials"
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.get('CLIENT_ID'),
    scopes: <String>[],
  );

  // Future<bool> get isSignedIn => _googleSignIn.isSignedIn();

  // Stream<GoogleSignInAccount?> get onCurrentUserChanged =>
  //     _googleSignIn.onCurrentUserChanged;

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;
      if (await _googleSignIn.isSignedIn()) {
        googleUser = await _googleSignIn.signInSilently();
      } else {
        googleUser = await _googleSignIn.signIn();
      }

      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

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
      throw Exception(e);
    }
  }
}
