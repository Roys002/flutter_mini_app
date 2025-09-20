import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth_service.dart';
import '../api/api_client.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _role;
  String? get role => _role;

  Future<void> login(String email, String password) async {
    final token = await AuthService.login(email, password);
    if (token != null) {
      final profile = await AuthService.getProfile();
      if (profile != null) {
        _role = profile["role"]; // ambil role dari API Laravel
        _isLoggedIn = true;
        // simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("role", _role!);
      }
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("role");
    notifyListeners();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = await ApiClient.getToken();
    final savedRole = prefs.getString("role");

    if (savedToken != null && savedRole != null) {
      _isLoggedIn = true;
      _role = savedRole;
      ApiClient.dio.options.headers["Authorization"] = "Bearer $savedToken";
    }
    notifyListeners();
  }
}
