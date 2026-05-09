import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// --------------------
// Cart Item Model
// --------------------
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final IconData icon;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.icon,
  });
}

// --------------------
// Cart Screen
// --------------------
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Example cart items (replace with Provider/Bloc in production)
  final List<CartItem> _cartItems = [
    CartItem(id: "1", name: "Cheese Burger", price: 120, icon: Icons.fastfood),
    CartItem(id: "2", name: "Veg Pizza", price: 250, icon: Icons.local_pizza),
  ];

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  void _incrementQty(CartItem item) {
    setState(() => item.quantity++);
  }

  void _decrementQty(CartItem item) {
    if (item.quantity > 1) {
      setState(() => item.quantity--);
    }
  }

  void _removeItem(CartItem item) {
    setState(() => _cartItems.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: AppColors.surfaceBg,
      ),
      body: _cartItems.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return Card(
            child: ListTile(
              leading: Icon(item.icon, color: AppColors.primaryYellow),
              title: Text(item.name,
                  style: const TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(
                "₹${item.price} x ${item.quantity} = ₹${item.price * item.quantity}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle,
                        color: AppColors.secondaryOrange),
                    onPressed: () => _decrementQty(item),
                  ),
                  Text("${item.quantity}",
                      style: const TextStyle(color: AppColors.textPrimary)),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.success),
                    onPressed: () => _incrementQty(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    onPressed: () => _removeItem(item),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total: ₹$totalPrice",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to checkout/payment screen
              },
              child: const Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
