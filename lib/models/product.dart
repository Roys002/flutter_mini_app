class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.tryParse(json["price"].toString()) ?? 0.0,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
