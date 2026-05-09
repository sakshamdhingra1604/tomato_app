import 'package:flutter/material.dart';
import '../../presentation/Screens/login/login_screen.dart';
import '../../presentation/Screens/onboard/complete_profile_screen.dart';
import '../../presentation/Screens/signup/signup_screen.dart';
import '../../presentation/Screens/main/main_screen.dart';

class AppRoutes {
  // Route names as constants (Production Standard)
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main'; // Ye Bottom Nav wali screen hai
  static const String completeProfile = '/complete-profile';

  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case completeProfile:
        return MaterialPageRoute(builder: (_) => const CompleteProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}