import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api", // ganti sesuai Laravel kamu
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  static Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("refresh_token", token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh_token");
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("refresh_token");
    dio.options.headers.remove("Authorization");
  }

  // interceptor untuk handle token expired
  static void setupInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // token expired → coba refresh
            final refreshed = await _refreshToken();
            if (refreshed) {
              // ulang request
              final opts = e.requestOptions;
              final cloneReq = await dio.request(
                opts.path,
                options: Options(method: opts.method, headers: opts.headers),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );
              return handler.resolve(cloneReq);
            } else {
              return handler.next(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        "/refresh",
        data: {"refresh_token": refreshToken},
      );

      final newAccess = response.data["access_token"];
      final newRefresh = response.data["refresh_token"];

      if (newAccess != null) {
        await setToken(newAccess);
      }
      if (newRefresh != null) {
        await setRefreshToken(newRefresh);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
