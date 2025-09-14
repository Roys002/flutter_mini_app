// lib/src/products/product_list_page.dart
import 'package:flutter/material.dart';
import '../common/api_client.dart';
import 'package:dio/dio.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];
  bool loading = true;

  Future<void> loadProducts() async {
    setState(() => loading = true);
    try {
      final response = await ApiClient.dio.get('/products'); // header Authorization sudah otomatis ada
      setState(() {
        products = response.data;
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        // token invalid/expired -> clear & go to login
        await ApiClient.clearToken();
        Navigator.pushReplacementNamed(context, '/');
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load products')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.dio.post('/logout'); // panggil api logout (opsional)
    } catch (e) {
      // ignore errors for logout
    }
    await ApiClient.clearToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return ListTile(
                  title: Text(p['name']),
                  subtitle: Text("\$${p['price']}"),
                );
              },
            ),
    );
  }
}
