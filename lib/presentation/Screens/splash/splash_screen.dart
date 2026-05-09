import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';
import '../Home/home_screen.dart';
import '../login/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    // 3 seconds ka delay taaki animation dikhe
    await Future.delayed(const Duration(milliseconds: 3000));

    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            FadeInDown(
              duration: const Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fastfood_rounded, size: 100, color: AppColors.primaryYellow),
              ),
            ),
            const SizedBox(height: 20),
            // Text Animation
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                "TOMATO",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: AppColors.primaryYellow,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeIn(
              delay: const Duration(milliseconds: 1000),
              child: const Text(
                "Campus Food, Simplified",
                style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}