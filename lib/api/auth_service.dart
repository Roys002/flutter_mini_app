import 'api_client.dart';

class AuthService {
  static Future<bool?> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final access = response.data["access_token"];
      final refresh = response.data["refresh_token"];

      if (access != null) {
        await ApiClient.setToken(access);
      }
      if (refresh != null) {
        await ApiClient.setRefreshToken(refresh);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await ApiClient.dio.get("/me");
      return response.data;
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await ApiClient.dio.post("/logout");
    } finally {
      await ApiClient.clearToken();
    }
  }
}
