import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Guard: if user is null, redirect to login
    if (currentUser == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login'); // <-- your login route
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                // HEADER SECTION
                Container(
                  padding: const EdgeInsets.only(top: 60, bottom: 30),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBg,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryYellow,
                        child: Icon(Icons.person, size: 50, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(userData['name'],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("${userData['degree']} | ${userData['rollNumber']}",
                          style: const TextStyle(color: Colors.white60)),
                      const SizedBox(height: 10),
                      Chip(
                        label: Text(userData['college']),
                        backgroundColor: AppColors.primaryYellow.withOpacity(0.2),
                        labelStyle: const TextStyle(color: AppColors.primaryYellow),
                      ),
                    ],
                  ),
                ),

                // COLLEGE INFO TILES
                ListTile(
                  leading: const Icon(Icons.business, color: AppColors.primaryYellow),
                  title: const Text("Block", style: TextStyle(color: Colors.white)),
                  subtitle: Text(userData['block'], style: const TextStyle(color: Colors.white38)),
                ),
                ListTile(
                  leading: const Icon(Icons.hotel, color: AppColors.primaryYellow),
                  title: const Text("Hosteller", style: TextStyle(color: Colors.white)),
                  subtitle: Text(userData['isHosteller'] ? "Yes" : "No", style: const TextStyle(color: Colors.white38)),
                ),

                const Divider(color: Colors.white10),

                // LOGOUT
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login'); // <-- redirect immediately
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
