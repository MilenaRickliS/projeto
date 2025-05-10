import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allProducts = Provider.of<ProductProvider>(context).products;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProducts = favoritesProvider.getFavoriteProductsFrom(allProducts);

    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body: favoriteProducts.isEmpty
          ? Center(child: Text('Nenhum produto favorito ainda.'))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favoriteProducts.length,
              itemBuilder: (ctx, i) => ProductItem(product: favoriteProducts[i]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
    );
  }
}
