import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    setState(() => _isLoading = true);
    try {
      // 1. Credential create karein
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      // 2. Firebase ke saath sign in karein
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Sign-in hote hi StreamBuilder (main.dart) apne aap HomeScreen par le jayega
      if (mounted) Navigator.popUntil(context, (route) => route.isFirst);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Text(
              "We've sent a 6-digit code to your phone.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
                hintText: "000000",
              ),
            ),
            const SizedBox(height: 25),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
              onPressed: _verifyOTP,
              child: const Text("Verify and Continue"),
            ),
          ],
        ),
      ),
    );
  }
}