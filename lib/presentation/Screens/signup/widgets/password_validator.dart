// lib/presentation/signup/widgets/password_requirement.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PasswordRequirement extends StatelessWidget {
  final String label;
  final bool isValid;

  const PasswordRequirement({super.key, required this.label, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: isValid ? AppColors.success : Colors.white38,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isValid ? AppColors.textPrimary : AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}