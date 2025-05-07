class Product {
  final String name;
  final String brand;
  final String imageLink;
  final double price;
  final String description;

  Product({required this.name, required this.brand, required this.imageLink, required this.price, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageLink: json['image_link'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}