import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  // TODO set cliend id
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "",
    scopes: <String>[
      'https://www.googleapis.com/auth/cloud-platform',
    ],
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
