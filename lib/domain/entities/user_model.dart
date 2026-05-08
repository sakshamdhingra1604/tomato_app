class UserModel {
  final String uid;
  final String name;
  final String rollNumber;
  final String email;
  final String role; // 'student' or 'vendor'

  UserModel({
    required this.uid,
    required this.name,
    required this.rollNumber,
    required this.email,
    this.role = 'student',
  });

  // Data ko Map mein badalne ke liye (Firestore ke liye)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'rollNumber': rollNumber,
      'email': email,
      'role': role,
      'createdAt': DateTime.now(),
    };
  }
}