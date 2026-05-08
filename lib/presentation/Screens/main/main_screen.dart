import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Yahan tumhari 4 screens aayengi
  final List<Widget> _pages = [
    const PlaceholderScreen(title: "Home (Cafes & Menus) 🍔"),
    const PlaceholderScreen(title: "Cart (Your Food) 🛒"),
    const PlaceholderScreen(title: "Orders (Live Tracking) 🛵"),
    const PlaceholderScreen(title: "Profile (Settings) 👤"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack state save rakhta hai
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: AppColors.surfaceBg, // Tumhara background color
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: AppColors.primaryYellow, // Tomato Yellow
          unselectedItemColor: Colors.white54,
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_filled),
              title: const Text("Home"),
            ),
            /// Cart
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              title: const Text("Cart"),
            ),
            /// Orders
            SalomonBottomBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long),
              title: const Text("Orders"),
            ),
            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              title: const Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Temporary Placeholder Screen (Taki code run ho sake)
// Baad mein inko original screens se replace kar dena
// ---------------------------------------------------------
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, color: AppColors.primaryYellow),
        ),
      ),
    );
  }
}