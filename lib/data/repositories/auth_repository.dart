import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 1. Email Sign Up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String rollNumber,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        rollNumber: rollNumber,
        email: email,
      );

      await _db.collection('users').doc(credential.user!.uid).set(newUser.toMap());
    } catch (e) { throw _handleError(e); }
  }

  // 2. Email Login
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) { throw _handleError(e); }
  }

  // 3. Google Sign In (SMOOTH FLOW)
  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Purana session clear
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Agar naya user hai toh Firestore mein profile banao
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _db.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'role': 'student',
          'createdAt': DateTime.now(),
        });
      }
    } catch (e) { throw "Google Sign-In failed: $e"; }
  }

  String _handleError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use': return "Ye email pehle se registered hai.";
        case 'invalid-credential': return "Email ya Password galat hai.";
        case 'weak-password': return "Password thoda strong rakho bhai.";
        default: return e.message ?? "Kuch error aaya hai.";
      }
    }
    return "Internet check karo ya fir se try karo.";
  }
}