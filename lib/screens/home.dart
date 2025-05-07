import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Catálogo de Produtos')),
      body: FutureBuilder(
        future: productProvider.fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: productProvider.products.length,
            itemBuilder: (ctx, i) => ProductItem(product: productProvider.products[i]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 4),
          );
        },
      ),
    );
  }
}