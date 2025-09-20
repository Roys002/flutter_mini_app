import 'api_client.dart';
import '../models/product.dart';

class ProductService {
  static Future<Map<String, dynamic>?> getProducts({
    int page = 1,
    String? name,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await ApiClient.dio.get("/products", queryParameters: {
        "page": page,
        if (name != null && name.isNotEmpty) "name": name,
        if (minPrice != null) "min_price": minPrice,
        if (maxPrice != null) "max_price": maxPrice,
      });

      return response.data["data"]; 
      // 👆 karena struktur JSON: {status, message, data:{data,links,meta}}
    } catch (e) {
      print(e);
      return null;
    }
  }
}
