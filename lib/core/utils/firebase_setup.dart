import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSetup {
  static Future<void> registerNewCafe({
    required String cafeName,
    required String password,
    required String imageUrl,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // 1. Create a unique Vendor ID
    String vendorId = firestore.collection('vendors').doc().id;

    // 2. Upload to Firestore
    await firestore.collection('vendors').doc(vendorId).set({
      'vendorId': vendorId,
      'cafeName': cafeName,
      'password': password, // Senior Note: In production, we hash this.
      'imageUrl': imageUrl,
      'isOpen': false, // By default band rahega
      'role': 'vendor',
    });

    print("✅ Cafe $cafeName registered successfully with ID: $vendorId");
  }
}