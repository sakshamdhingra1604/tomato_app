import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged; // Optional banaya hai

  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged, // 👈 Connect ho gaya!
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryYellow, size: 20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}