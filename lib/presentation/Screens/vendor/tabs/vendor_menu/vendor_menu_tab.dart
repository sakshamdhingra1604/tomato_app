// screens/vendor/menu/vendor_menu_tab.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/services/firebase_menu_service.dart';
import '../../../../../core/services/storage_service.dart';
import 'add_item_screen.dart';

class VendorMenuTab extends StatefulWidget {
  const VendorMenuTab({super.key});

  @override
  State<VendorMenuTab> createState() => _VendorMenuTabState();
}

class _VendorMenuTabState extends State<VendorMenuTab> {
  String? currentVendorId;

  @override
  void initState() {
    super.initState();
    _loadVendor();
  }

  void _loadVendor() async {
    String? id = await StorageService.getVendorId();
    if (mounted) setState(() => currentVendorId = id);
  }

  @override
  Widget build(BuildContext context) {
    if (currentVendorId == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Menu", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddItemScreen())),
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Item", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('menu')
            .where('vendorId', isEqualTo: currentVendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your menu is empty. Add your first dish!"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;
              return _buildMenuItemCard(doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuItemCard(String docId, Map<String, dynamic> data) {
    bool isAvailable = data['isAvailable'] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: data['imageUrl'] != null
                      ? CachedNetworkImage(
                    imageUrl: data['imageUrl'],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey.shade100),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                      : Container(color: Colors.grey.shade100, child: const Center(child: Icon(Icons.fastfood, color: Colors.grey))),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => _confirmDelete(docId),
                    child: CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: const Icon(Icons.close, size: 14, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['itemName'] ?? "Unnamed", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (data['specialPrice'] != null && data['specialPrice'] > 0) ...[
                      Text("₹${data['price']}", style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 5),
                      Text("₹${data['specialPrice']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                    ] else ...[
                      Text("₹${data['price']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("In Stock", style: TextStyle(fontSize: 12)),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: isAvailable,
                        onChanged: (val) => FirebaseMenuService().toggleStatus(docId, isAvailable),
                        activeColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemScreen(editData: data, docId: docId))),
                    style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    child: const Text("Edit", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item?"),
        content: const Text("Kya aap ise menu se permanent hatana chahte hain?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseMenuService().deleteItem(docId);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}