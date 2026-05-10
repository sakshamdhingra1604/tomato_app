// core/services/firebase_menu_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMenuService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 1. ADD ITEM
  Future<void> addItem({
    required String vendorId,
    required String itemName,
    required int price,
    int? specialPrice,
    required int prepTime,
    required String category,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        String fileName = 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref = _storage.ref().child('menu_images').child(vendorId).child(fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      await _db.collection('menu').add({
        'vendorId': vendorId,
        'itemName': itemName,
        'price': price,
        'specialPrice': specialPrice ?? 0,
        'prepTime': prepTime,
        'category': category,
        'imageUrl': imageUrl,
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add item: $e");
    }
  }

  // 2. UPDATE ITEM
  Future<void> updateItem({
    required String docId,
    required String vendorId,
    required String itemName,
    required int price,
    int? specialPrice,
    required int prepTime,
    required String category,
    File? imageFile,
    String? oldImageUrl,
  }) async {
    try {
      String? finalImageUrl = oldImageUrl;

      if (imageFile != null) {
        // Purani image delete karna safe rakha hai
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          try {
            await _storage.refFromURL(oldImageUrl).delete();
          } catch (e) {
            print("Old image delete failed (might not exist): $e");
          }
        }

        String fileName = 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref = _storage.ref().child('menu_images').child(vendorId).child(fileName);
        await ref.putFile(imageFile);
        finalImageUrl = await ref.getDownloadURL();
      }

      await _db.collection('menu').doc(docId).update({
        'itemName': itemName,
        'price': price,
        'specialPrice': specialPrice ?? 0,
        'prepTime': prepTime,
        'category': category,
        'imageUrl': finalImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Update failed: $e");
    }
  }

  // 3. TOGGLE STATUS
  Future<void> toggleStatus(String docId, bool currentStatus) async {
    try {
      await _db.collection('menu').doc(docId).update({
        'isAvailable': !currentStatus,
      });
    } catch (e) {
      throw Exception("Toggle failed: $e");
    }
  }

  // 4. DELETE ITEM
  Future<void> deleteItem(String docId) async {
    try {
      DocumentSnapshot doc = await _db.collection('menu').doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String? imageUrl = data['imageUrl'];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            await _storage.refFromURL(imageUrl).delete();
          } catch (e) {
            print("Image deletion failed during item delete: $e");
          }
        }
        await _db.collection('menu').doc(docId).delete();
      }
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }
}