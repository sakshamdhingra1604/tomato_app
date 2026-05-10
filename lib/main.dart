// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginsignuptesting/presentation/Screens/vendor/vendor_dashboard.dart';

// In imports ko apne project structure ke hisaab se verify kar lena
import 'core/services/storage_service.dart';
import 'presentation/Screens/login/login_screen.dart';
import 'presentation/Screens/main/main_screen.dart';
import 'presentation/Screens/onboard/complete_profile_screen.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Injection initialized hona chahiye taaki services mil sakein
  await initInjection();

  // 🔥 SENIOR LOGIC: Sabse pehle local storage check karo (Fastest)
  // Limited vendors hain, isliye unka session local storage mein save rakhna best hai.
  bool isVendor = await StorageService.isVendorLoggedIn();

  runApp(TomatoApp(isVendorLoggedIn: isVendor));
}

class TomatoApp extends StatelessWidget {
  final bool isVendorLoggedIn;
  const TomatoApp({super.key, required this.isVendorLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomato - Campus Food',
      theme: AppTheme.darkTheme,

      // 🔥 ROUTING DECISION:
      // 1. Agar vendor session mil gaya, seedha Vendor Dashboard.
      // 2. Agar nahi mila, toh Student login/session check karne ke liye AuthWrapper bhejo.
      home: isVendorLoggedIn
          ? const VendorDashboard()
          : const AuthWrapper(),

      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Jab tak Firebase check kar raha hai, loading dikhao
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 🔥 STUDENT LOGIC (For large numbers):
        if (authSnapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(authSnapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              // Check if Student Profile is already set up
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                if (data != null && data['profileCompleted'] == true) {
                  return const MainScreen();
                }
              }
              // Naya student hai toh profile complete karao
              return const CompleteProfileScreen();
            },
          );
        }

        // Agar na Vendor login hai na Student, toh Login Screen (Student Login default)
        return const LoginScreen();
      },
    );
  }
}