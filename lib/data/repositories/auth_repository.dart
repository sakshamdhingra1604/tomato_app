import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- HELPER METHODS ---

  // Isse screen ko pata chalega ki login success hua ya nahi
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Purana session clear karo taaki har baar account chooser dikhe
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User ne cancel kar diya

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2. Firebase se sign in karo aur credential return karo
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw "Google Sign-In failed: $e";
    }
  }




  // Check if Roll Number already exists in PIET (Ya kisi bhi college mein)
  Future<bool> isRollNumberTaken(String rollNo) async {
    final result = await _db
        .collection('users')
        .where('rollNumber', isEqualTo: rollNo)
        .get();
    return result.docs.isNotEmpty;
  }

  // Check if User Profile is actually completed in Firestore
  Future<bool> isProfileComplete(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    return doc.exists && (doc.data() as Map<String, dynamic>).containsKey('profileCompleted');
  }

  // --- CORE AUTH METHODS ---

  // 1. Email Sign Up (Initial step)
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sirf Auth create kar rahe hain, details hum "Complete Profile" screen pe lenge
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 2. Email Login
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 3. Google Sign In (Gatekeeper Flow)
  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;

      // 🔥 SENIOR DEV LOGIC: Check if profile exists in Firestore
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();

      if (userDoc.exists && (userDoc.data() as Map<String, dynamic>).containsKey('profileCompleted')) {
        // User registered hai -> Home bhejo
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        }
      } else {
        // User naya hai ya profile incomplete hai -> Complete Profile bhejo
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/complete-profile', (route) => false);
        }
      }
    } catch (e) {
      throw "Google Sign-In Error: $e";
    }
  }

  // 4. Save Final Production Profile (Firestore)
  // Jab user CompleteProfileScreen pe details bharega, tab ye call hoga
  Future<void> finalizeUserProfile(UserModel user) async {
    try {
      // Double check for Roll Number uniqueness before final save
      bool taken = await isRollNumberTaken(user.rollNumber);
      if (taken) throw "Ye Roll Number pehle se registered hai!";

      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw "Profile save karne mein dikat aayi: $e";
    }
  }

  // 5. Logout (Clean)
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String _handleError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use': return "Ye email pehle se registered hai.";
        case 'invalid-credential': return "Email ya Password galat hai.";
        case 'weak-password': return "Password thoda strong rakho bhai.";
        case 'user-disabled': return "Ye account block kar diya gaya hai.";
        default: return e.message ?? "Authentication failed.";
      }
    }
    return "Internet check karo ya fir se try karo.";
  }
}