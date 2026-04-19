import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _initialized = false;

  /// Stream of the currently signed-in Firebase user (null = signed out).
  Stream<User?> get userStream => _auth.authStateChanges();

  /// The currently signed-in user, or null.
  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => _auth.currentUser != null;

  /// Signs in with Google and links to Firebase Auth.
  /// Returns the Firebase [User] on success.
  Future<User?> signInWithGoogle() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }

    final googleAccount = await GoogleSignIn.instance.authenticate();
    final tokens = await googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: tokens.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
