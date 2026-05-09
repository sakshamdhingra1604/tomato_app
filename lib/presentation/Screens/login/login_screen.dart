// ✅ GALAT import hata kar tumhara original routes import dala hai
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:loginsignuptesting/core/routes/app_routes.dart'; // Sahi import
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../injection.dart';
import '../signup/signup_screen.dart';
import '../vendor/auth/vendor_login_screen.dart';
import 'widgets/auth_field.dart';
import 'widgets/social_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = getIt<AuthRepository>();
  bool _isLoading = false;

  void _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showProfessionalError("Bhai, email aur password toh bharo!");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepo.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // ✅ Navigator fix: 'as String' hata kar direct constant use kiya
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
      }
    } catch (e) {
      _showProfessionalError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  // Screen ke andar ka method
  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      // 🔥 Ab Repository method ka naam aur return type match karega
      UserCredential? userCredential = await _authRepo.signInWithGoogle();

      if (userCredential != null && mounted) {
        final String uid = userCredential.user!.uid;

        // 🔥 GATEKEEPER LOGIC: Screen decide karegi kahan jana hai
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists && (userDoc.data() as Map<String, dynamic>).containsKey('profileCompleted')) {
          // Purana User (PIET Student)
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        } else {
          // Naya User ya incomplete data
          Navigator.pushNamedAndRemoveUntil(context, '/complete-profile', (route) => false);
        }
      }
    } catch (e) {
      _showProfessionalError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showProfessionalError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... Baki build method ka code tumhara wala hi hai (No changes)
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: const Text("Tomato 🍅",
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.primaryYellow)),
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: const Text("Skip the queue, enjoy the food.",
                        style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 50),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: AuthField(
                      controller: _emailController,
                      hintText: "College Email Address",
                      icon: Icons.email_outlined,
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 500),
                    child: AuthField(
                      controller: _passwordController,
                      hintText: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FadeIn(
                      delay: const Duration(milliseconds: 600),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primaryYellow)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
                      onPressed: _isLoading ? null : _handleEmailLogin,
                      child: const Text("Sign In"),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(child: FadeIn(child: const Text("OR", style: TextStyle(color: Colors.white38)))),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: SocialButton(
                      onTap: _handleGoogleSignIn,
                      label: "Continue with Google",
                      icon: Image.asset('assets/logos/google.png', height: 24),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: SocialButton(
                      onTap: () {},
                      label: "Sign in with Phone",
                      icon: const Icon(Icons.phone_android, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 900),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?", style: TextStyle(color: AppColors.textSecondary)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                          },
                          child: const Text("Sign Up", style: TextStyle(color: AppColors.primaryYellow, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: Column(
                      children: [
                        const Text("Are you a Cafe Owner?", style: TextStyle(color: AppColors.textSecondary)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  VendorLoginScreen()),
                            );
                          },
                          child: const Text(
                            "Vendor Login Here",
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryYellow),
              ),
            ),
        ],
      ),
    );
  }
}