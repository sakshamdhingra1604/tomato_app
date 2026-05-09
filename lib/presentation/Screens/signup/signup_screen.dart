import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:loginsignuptesting/core/routes/app_routes.dart';
import 'package:loginsignuptesting/presentation/Screens/signup/widgets/password_validator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../injection.dart';
import '../login/widgets/auth_field.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepo = getIt<AuthRepository>();
  bool _isLoading = false;

  // Password Validation Logic
  bool get hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasDigits => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get hasMinLength => _passwordController.text.length >= 8;

  void _handleSignup() async {
    // Basic Validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError("Fields khali mat chhodo bhai!");
      return;
    }

    if (!hasMinLength || !hasUppercase || !hasDigits || !hasSpecialChar) {
      _showError("Password criteria poora nahi hai!");
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Step 1: Create Firebase Auth Account
      await _authRepo.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Step 2: Redirect to Complete Profile (Details wahan bhari jayengi)
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/complete-profile');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: const Text("Set up your login to join PIET Tomato", style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 40),

                  // Sirf Email aur Password ki fields
                  AuthField(
                    controller: _emailController,
                    hintText: "College Email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: _passwordController,
                    hintText: "Create Password",
                    icon: Icons.lock_open_outlined,
                    obscureText: true,
                    onChanged: (val) => setState(() {}),
                  ),

                  const SizedBox(height: 25),

                  // Password Indicator Box
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

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      backgroundColor: AppColors.primaryYellow,
                    ),
                    onPressed: _isLoading ? null : _handleSignup,
                    child: const Text("Continue to Profile Setup", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black87,
              child: const Center(child: CircularProgressIndicator(color: AppColors.primaryYellow)),
            ),
        ],
      ),
    );
  }
}