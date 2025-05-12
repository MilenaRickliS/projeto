import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/menu.dart';

class FilteredProductsScreen extends StatelessWidget {
  final String category;

  const FilteredProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context)
        .products
        .where((p) => p.productType == category)
        .toList();
      return MainScaffold(
        selectedIndex: 0, 
        body: Scaffold(
        appBar: AppBar(title: Text('Categoria: $category')),
        body: products.isEmpty
            ? Center(child: Text('Nenhum produto encontrado.'))
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: products.length,
                itemBuilder: (ctx, i) => ProductItem(product: products[i]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
        ),
      );
  }
}
