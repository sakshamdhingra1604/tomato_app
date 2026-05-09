import 'package:flutter/material.dart';

class VendorOrdersTab extends StatelessWidget {
  const VendorOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Orders 🕒"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5, // Temporary count
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                child: const Icon(Icons.fastfood, color: Colors.redAccent),
              ),
              title: Text("Order #102$index", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("1x Masala Dosa, 2x Chai\nStatus: Pending"),
              trailing: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Accept", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}