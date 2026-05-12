// lib/presentation/Screens/home/home_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginsignuptesting/presentation/Screens/Home/tabs/vendor_menu_screen.dart';
import '../../widgets/vendor_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 🔥 COLLEGE NAME: Firestore ke 'collegeName' field se exact match hona chahiye
  final String currentStudentCollege = "Panipat Institute of Engineering and Technology (PIET)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Tomato Campus 🍅",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query: Sirf usi college ke vendors fetch karo
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .where('collegeName', isEqualTo: currentStudentCollege)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Error Handling
          if (snapshot.hasError) {
            return const Center(
              child: Text("Connection Error. Check Internet.", style: TextStyle(color: Colors.grey)),
            );
          }

          // 2. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          }

          // 3. Empty State (Agar college mein koi vendor na ho)
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85, // Thoda height adjust kiya hai cards ke liye
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Document fetch karo
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>?;

              if (data == null) return const SizedBox();

              // 🔥 PRODUCTION DATA MAPPING: Firestore fields ke exact names
              // 'cafeName' aur 'imageUrl' wahi hain jo tumhare screenshot mein hain
              String cafeName = data['cafeName']?.toString() ?? 'Unnamed Cafe';
              String imgUrl = data['imageUrl']?.toString() ?? '';

              // vendorId priority: Firestore field 'vendorId' ya fir Document ID
              String vId = data['vendorId']?.toString() ?? doc.id;

              return VendorCard(
                name: cafeName,
                imageUrl: imgUrl,
                onTap: () {
                  debugPrint("Navigating to: $cafeName (ID: $vId)");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorMenuScreen(
                        vendorId: vId,
                        vendorName: cafeName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 60, color: Colors.grey[800]),
          const SizedBox(height: 16),
          const Text(
            "No cafes found for your college.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}