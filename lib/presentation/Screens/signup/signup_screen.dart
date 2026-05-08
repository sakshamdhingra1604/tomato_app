// ✅ GALAT import hata kar tumhara original routes import dala hai
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:loginsignuptesting/core/routes/app_routes.dart'; // Sahi import
import 'package:loginsignuptesting/presentation/Screens/signup/widgets/password_validator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../login/widgets/auth_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ... controllers aur validators (No changes)
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;

  bool get hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasDigits => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get hasMinLength => _passwordController.text.length >= 8;

  void _handleSignup() async {
    if (!hasMinLength || !hasUppercase || !hasDigits || !hasSpecialChar) {
      _showError("Password criteria poora nahi hai bhai!");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepo.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        rollNumber: _rollController.text.trim(),
      );
      // ✅ Navigator fix
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... Baki build method ka code tumhara wala hi hai (No changes)
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    child: const Text("Create Account 🍅",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryYellow)),
                  ),
                  const SizedBox(height: 10),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: const Text("Join the Tomato community", style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 30),
                  AuthField(controller: _nameController, hintText: "Full Name", icon: Icons.person_outline),
                  const SizedBox(height: 15),
                  AuthField(
                    controller: _rollController,
                    hintText: "Roll Number (e.g. 2822001)",
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  AuthField(controller: _emailController, hintText: "College Email", icon: Icons.email_outlined),
                  const SizedBox(height: 15),
                  AuthField(
                    controller: _passwordController,
                    hintText: "Create Password",
                    icon: Icons.lock_open_outlined,
                    obscureText: true,
                    onChanged: (val) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        PasswordRequirement(label: "At least 8 characters", isValid: hasMinLength),
                        const SizedBox(height: 8),
                        PasswordRequirement(label: "One Uppercase letter", isValid: hasUppercase),
                        const SizedBox(height: 8),
                        PasswordRequirement(label: "One Number", isValid: hasDigits),
                        const SizedBox(height: 8),
                        PasswordRequirement(label: "One Special character", isValid: hasSpecialChar),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
                    onPressed: _isLoading ? null : _handleSignup,
                    child: const Text("Create Tomato Account"),
                  ),
                  const SizedBox(height: 20),
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