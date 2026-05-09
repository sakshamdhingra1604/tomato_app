import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> cafes = const [
    "Froot Shoot",
    "Nescafe",
    "Deepak",
    "Old Canteen",
    "Cafe14",
    "Onestop",
    "College Cafe",
    "Bunny Kitchen",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Cafés"),
        backgroundColor: AppColors.surfaceBg,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cafés per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: cafes.length,
        itemBuilder: (context, index) {
          final cafe = cafes[index];
          return Card(
            color: AppColors.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to cafe details screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Opening $cafe...")),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  cafe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
    MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    ),
  );
}
