// lib/presentation/Screens/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../CartScreen/cart_screen.dart';
import '../Home/home_screen.dart';
import '../OrdersScreen/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../../../core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // REAL SCREENS CONNECTED HERE
  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        color: AppColors.surfaceBg,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          selectedItemColor: AppColors.primaryYellow,
          unselectedItemColor: Colors.white54,
          items: [
            SalomonBottomBarItem(icon: const Icon(Icons.home_outlined), title: const Text("Home")),
            SalomonBottomBarItem(icon: const Icon(Icons.shopping_cart_outlined), title: const Text("Cart")),
            SalomonBottomBarItem(icon: const Icon(Icons.receipt_long_outlined), title: const Text("Orders")),
            SalomonBottomBarItem(icon: const Icon(Icons.person_outline), title: const Text("Profile")),
          ],
        ),
      ),
    );
  }
}