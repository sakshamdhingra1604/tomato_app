class VendorModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final bool isOpen;

  VendorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    this.isOpen = true,
  });

  // Firestore Map ko Object mein badalne ke liye
  factory VendorModel.fromMap(Map<String, dynamic> map, String docId) {
    return VendorModel(
      id: docId,
      name: map['vendorName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? 'Campus Favorite',
      isOpen: map['isOpen'] ?? true,
    );
  }
}