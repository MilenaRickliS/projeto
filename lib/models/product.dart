import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String imageLink;
  final double price;
  final String description;
  final String productType;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageLink,
    required this.price,
    required this.description,
    required this.productType,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? const Uuid().v4(), 
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageLink: json['image_link'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      productType: json['product_type'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
