import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyIsVendor = "isVendor";
  static const String _keyVendorId = "vendorId";
  static const String _keyVendorName = "vendorName";

  static Future<void> saveVendorSession(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsVendor, true);
    await prefs.setString(_keyVendorId, id);
    await prefs.setString(_keyVendorName, name);
  }

  static Future<bool> isVendorLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsVendor) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}