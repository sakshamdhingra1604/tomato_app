import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';

class VendorProfileTab extends StatelessWidget {
  const VendorProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cafe Settings")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.store, size: 50)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await StorageService.clearSession();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout Vendor Mode"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}