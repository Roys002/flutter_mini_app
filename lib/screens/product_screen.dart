import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameCtrl = TextEditingController();

  double _minPrice = 0;
  double _maxPrice = 20000;

  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductProvider>().fetchProducts();
      }
    });
  }

  void _applyFilter() {
    final provider = context.read<ProductProvider>();
    provider.setFilters(
      name: _nameCtrl.text,
      min: _minPrice,
      max: _maxPrice,
    );
    provider.refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => _buildFilterSheet(),
              );
            },
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text("Produk tidak ditemukan"));
          }

          return RefreshIndicator(
            onRefresh: () async => provider.refreshProducts(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: provider.products.length +
                  (provider.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < provider.products.length) {
                  final p = provider.products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.description),
                      trailing: Text("Rp ${p.price.toStringAsFixed(2)}"),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: "Cari produk",
            ),
          ),
          const SizedBox(height: 16),
          Text("Harga: Rp $_minPrice - Rp $_maxPrice"),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 2000,
            divisions: 20,
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilter();
            },
            child: const Text("Terapkan Filter"),
          )
        ],
      ),
    );
  }
}
