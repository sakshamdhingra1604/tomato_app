import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 1. Email/Password Logic (Signup & Login dono ke liye)
  Future<void> handleEmailAuth({
    required String email,
    required String password,
    required bool isSignup
  }) async {
    if (isSignup) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } else {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }
  }

  // 2. Google Sign-In Logic
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  // 3. Phone Authentication Logic
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? "Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // 4. Logout
  Future<void> signOut() async {
    await GoogleSignIn().disconnect(); // Ye link tod dega taaki next time account chooser khule
    await FirebaseAuth.instance.signOut();
  }
  }
