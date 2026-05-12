import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorMenuScreen extends StatelessWidget {
  final String vendorId;
  final String vendorName;

  const VendorMenuScreen({
    super.key,
    required this.vendorId,
    required this.vendorName
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(vendorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu')
            .where('vendorId', isEqualTo: vendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading menu", style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No items available in this cafe.",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          final menuDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menuDocs.length,
            itemBuilder: (context, index) {
              var data = menuDocs[index].data() as Map<String, dynamic>;

              String itemName = data['itemName']?.toString() ?? "No Title";
              num price = data['price'] ?? 0;
              num specialPrice = data['specialPrice'] ?? 0;
              int prepTime = data['prepTime'] ?? 0;
              String imgUrl = (data['imageUrl'] ?? "").toString().trim();
              bool isAvailable = data['isAvailable'] ?? false;

              if (!isAvailable) return const SizedBox();

              return _buildItemCard(itemName, price, specialPrice, prepTime, imgUrl);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(String name, num price, num sPrice, int time, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Image with Error Handling
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: img.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: img,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.white10),
              // 404 error ke liye fallback icon
              errorWidget: (context, url, error) => Container(
                color: Colors.white10,
                child: const Icon(Icons.fastfood, color: Colors.white24, size: 30),
              ),
            )
                : Container(width: 80, height: 80, color: Colors.white10, child: const Icon(Icons.fastfood, color: Colors.white24)),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$time mins prep", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("₹$sPrice", style: const TextStyle(color: Colors.greenAccent, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    if (sPrice < price)
                      Text("₹$price", style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough)),
                  ],
                ),
              ],
            ),
          ),

          // 🔥 FIXED: Wrap ElevatedButton with a fixed width to prevent "Infinite Width" error
          SizedBox(
            width: 70,
            height: 35,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.zero, // Padding zero rakho taaki small button mein text aa sake
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}