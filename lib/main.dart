// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginsignuptesting/presentation/Screens/login/login_screen.dart';
import 'package:loginsignuptesting/presentation/Screens/main/main_screen.dart';
import 'package:loginsignuptesting/presentation/Screens/onboard/complete_profile_screen.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //🔥 Iske bina GetIt error dega "Object not found"
  await initInjection();
  runApp(const TomatoApp());
}
// lib/main.dart
class TomatoApp extends StatelessWidget {
  const TomatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomato - Campus Food',
      theme: AppTheme.darkTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (authSnapshot.hasData) {
            // 🔥 SENIOR LOGIC: Check if Profile is completed in Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(authSnapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final data = userSnapshot.data!.data() as Map<String, dynamic>?;
                  // Agar profileCompleted flag true hai toh hi MainScreen
                  if (data != null && data['profileCompleted'] == true) {
                    return const MainScreen();
                  }
                }
                // Agar document nahi hai ya profile incomplete hai
                return const CompleteProfileScreen();
              },
            );
          }
          return const LoginScreen();
        },
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}