import 'package:flutter/material.dart';
import 'tabs/vendor_orders_tab.dart';
import 'tabs/vendor_menu/vendor_menu_tab.dart';
import 'tabs/vendor_earnings_tab.dart';
import 'tabs/vendor_profile_tab.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const VendorOrdersTab(),    // Tab 1: Orders
    const VendorMenuTab(),      // Tab 2: Menu
    const VendorEarningsTab(),  // Tab 3: Finance
    const VendorProfileTab(),    // Tab 4: Profile & Logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // 4 items ke liye fixed best hai
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}