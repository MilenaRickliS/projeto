import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'categorias_produtos.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final categories = products.map((p) => p.productType).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: Text('Filtrar por Categoria')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilteredProductsScreen(category: categories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
