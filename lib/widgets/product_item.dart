import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/detalhes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Image.network(product.imageLink, height: 100, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text('R\$ ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.pink)),
          ],
        ),
      ),
    );
  }
}