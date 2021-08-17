import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final GoogleSignIn _googleSignIn;
  UserRepository({GoogleSignIn? signIn}) : _googleSignIn = signIn ?? GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return FirebaseAuth.instance.signInWithCredential(credential);
    }

    return Future.value(null);
  }

  Future<bool> signOut() async {
    bool signedOut = false;
    await Future.wait([
      _googleSignIn.signOut(),
      FirebaseAuth.instance.signOut(),
    ]).then((_) => signedOut = true);

    return signedOut;
  }

  Future<bool> isSignedIn() async {
    final signedInStatus = await _googleSignIn.isSignedIn();
    return signedInStatus;
  }
}
