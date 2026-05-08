import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart'; // Apna route file import karo
// baki imports...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tomato App',
      theme: ThemeData.dark(), // Ya jo bhi tumhara theme hai

      // 🔥 PRODUCTION ROUTING 🔥
      initialRoute: AppRoutes.login, // Start Login se hoga
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}