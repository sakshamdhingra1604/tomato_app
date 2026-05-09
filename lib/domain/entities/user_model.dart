// lib/domain/entities/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String college;
  final String degree; // CSE, ECE, Pharmacy, MBA etc.
  final String rollNumber;
  final String year;
  final String block; // A, B, C, G, D, E, Academics
  final bool isHosteller;
  final String gender;

  UserModel({
    required this.uid, required this.name, required this.email,
    required this.college, required this.degree, required this.rollNumber,
    required this.year, required this.block, required this.isHosteller,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, 'name': name, 'email': email,
      'college': college, 'degree': degree, 'rollNumber': rollNumber,
      'year': year, 'block': block, 'isHosteller': isHosteller,
      'gender': gender,
      'profileCompleted': true, // Taaki check kar sakein profile bani ya nahi
    };
  }
}