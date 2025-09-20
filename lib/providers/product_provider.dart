import 'package:flutter/material.dart';
import '../models/product.dart';
import '../api/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? filterName;
  double? filterMinPrice;
  double? filterMaxPrice;

  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && _currentPage > _lastPage) return;

    _isLoading = true;
    notifyListeners();

    if (refresh) {
      _products = [];
      _currentPage = 1;
    }

    final result = await ProductService.getProducts(
      page: _currentPage,
      name: filterName,
      minPrice: filterMinPrice,
      maxPrice: filterMaxPrice,
    );

    if (result != null) {
      final List data = result["data"];
      final meta = result["meta"];

      _lastPage = meta["last_page"];
      _products.addAll(data.map((json) => Product.fromJson(json)).toList());
      _currentPage++;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilters({String? name, double? min, double? max}) {
    filterName = name;
    filterMinPrice = min;
    filterMaxPrice = max;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await fetchProducts(refresh: true);
  }
}
