import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final String baseUrl = "http://127.0.0.1:8000/api";
  static late Dio dio;
  static String? _token;

    static Future<void> init() async {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl, 
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      ));
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  static Future<void> setToken(String token) async {
    _token = token;
    dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    dio.options.headers.remove('Authorization');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static String? get token => _token;
}
