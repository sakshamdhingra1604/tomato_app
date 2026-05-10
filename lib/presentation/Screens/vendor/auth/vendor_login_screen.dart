import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Agar tum StorageService use karna chaho to iski jagah apna service import karo
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  String? selectedVendorId;
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleVendorLogin() async {
    if (selectedVendorId == null || _passController.text.isEmpty) {
      _showSnackbar("Details bharo bhai!", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(selectedVendorId)
          .get();

      if (doc.exists && doc['password'] == _passController.text) {
        // 🔥 Save vendor session locally
        await StorageService.saveVendorSession(selectedVendorId!, doc['cafeName']);

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.vendorDashboard,
                (route) => false,
          );
        }
      } else {
        _showSnackbar("Password galat hai!", Colors.red);
      }
    } catch (e) {
      _showSnackbar("Connection Error: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Login")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildVendorDropdown(),
            const SizedBox(height: 20),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleVendorLogin,
              child: const Text("Enter Dashboard"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Improved Dropdown with error + empty handling
  Widget _buildVendorDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, snapshot) {
        // 1. Agar net ya rules ka issue hai toh ye bata dega
        if (snapshot.hasError) {
          return Text(
            "Firebase Error: ${snapshot.error}",
            style: const TextStyle(color: Colors.red),
          );
        }

        // 2. Jab tak data nahi aata
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        // 3. Agar data aa gaya par collection khali hai
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No Cafes found. Check Collection Name!");
        }

        return DropdownButtonFormField<String>(
          value: selectedVendorId,
          items: snapshot.data!.docs.map((doc) {
            return DropdownMenuItem(
              value: doc.id,
              child: Text(doc['cafeName'] ?? "Unknown"),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedVendorId = v),
          decoration: const InputDecoration(
            labelText: "Select Cafe",
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
