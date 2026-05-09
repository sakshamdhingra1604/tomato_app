import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';

// --------------------
// Order Model
// --------------------
class Order {
  final String id;
  final String title;
  final double total;
  final DateTime date;
  final List<String> items;

  Order({
    required this.id,
    required this.title,
    required this.total,
    required this.date,
    required this.items,
  });
}

// --------------------
// Orders Provider
// --------------------
class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.insert(0, order); // newest first
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}

// --------------------
// Orders Screen
// --------------------
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: AppColors.surfaceBg,
      ),
      body: orders.isEmpty
          ? const Center(
        child: Text(
          "No orders yet",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: ListTile(
              title: Text(
                order.title,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                "₹${order.total} • ${order.date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                // Simple order details popup
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.cardBg,
                    title: Text("Order #${order.id}",
                        style: const TextStyle(color: AppColors.textPrimary)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order.items
                          .map((item) => Text(
                        "• $item",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ))
                          .toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close",
                            style: TextStyle(color: AppColors.primaryYellow)),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --------------------
// Example Main
// --------------------
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => OrdersProvider()
        ..addOrder(Order(
          id: "101",
          title: "Food Order",
          total: 370,
          date: DateTime.now(),
          items: ["Cheese Burger", "Veg Pizza"],
        ))
        ..addOrder(Order(
          id: "102",
          title: "Snacks Order",
          total: 150,
          date: DateTime.now().subtract(const Duration(days: 1)),
          items: ["French Fries", "Coke"],
        )),
      child: MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: const OrdersScreen(),
      ),
    ),
  );
}
