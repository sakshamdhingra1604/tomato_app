import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Widget icon;
  final Color color;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    this.color = Colors.white10,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: icon,
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        side: BorderSide.none,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}