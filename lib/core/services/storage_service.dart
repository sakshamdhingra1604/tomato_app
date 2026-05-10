import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Keys ko private rakha hai taaki typos na hon
  static const String _keyIsVendor = "isVendor";
  static const String _keyVendorId = "vendorId";
  static const String _keyVendorName = "vendorName";

  // --- SAVE DATA ---
  static Future<void> saveVendorSession(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsVendor, true);
    await prefs.setString(_keyVendorId, id);
    await prefs.setString(_keyVendorName, name);
    print("✅ Session Saved: ID: $id, Name: $name");
  }

  // --- READ DATA (The Important Part for Day 3) ---

  // 1. Check if logged in
  static Future<bool> isVendorLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsVendor) ?? false;
  }

  // 2. Get Vendor ID (Isi se menu filter hoga)
  static Future<String?> getVendorId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_keyVendorId);
    return id;
  }

  // 3. Get Vendor Name (Dashboard pe "Welcome, Nescafe" dikhane ke liye)
  static Future<String?> getVendorName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyVendorName);
  }

  // --- CLEAR DATA ---
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🧹 Session Cleared Successfully");
  }
}