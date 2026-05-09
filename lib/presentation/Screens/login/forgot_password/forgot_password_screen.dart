import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: const Text("Forgot Password? 🔑",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.primaryYellow)),
            ),
            const SizedBox(height: 10),
            const Text("Darrne ki baat nahi hai! Apna email daalein, hum link bhej denge.",
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            AuthField(controller: _emailController, hintText: "College Email", icon: Icons.email_outlined, onChanged: (val) {  },),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Password reset logic yahan aayega
              },
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}