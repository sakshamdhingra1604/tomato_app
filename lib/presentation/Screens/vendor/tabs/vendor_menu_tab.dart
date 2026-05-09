import 'package:flutter/material.dart';

class VendorMenuTab extends StatelessWidget {
  const VendorMenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Management 🍔")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Baad mein yahan "Add Item" form kholenge
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey, // Temporary Placeholder
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: const Center(child: Icon(Icons.image, color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("Item Name", style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text("₹99.00", style: TextStyle(color: Colors.green)),
                      Switch(value: true, onChanged: (val) {}), // Availability Toggle
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}