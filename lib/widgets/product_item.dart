import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/detalhes.dart';
import 'package:projeto/providers/cart_provider.dart';
import 'package:projeto/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  
  final Product product;

  const ProductItem({super.key, required this.product});
  @override
  ProductItemState createState() => ProductItemState();
}

class ProductItemState extends State<ProductItem> {  

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: widget.product))
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: widget.product.imageLink,
                child: Image.network(
                  widget.product.imageLink,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/download.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(widget.product.name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text('R\$ ${widget.product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.pink)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.product.name} foi adicionado ao carrinho!')),
                    );
                  },
                ),
                Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, _) {
                    final isFav = favoritesProvider.isFavorite(widget.product.id);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null,
                      ),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(widget.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                            isFav
                              ? '${widget.product.name} removido dos favoritos.'
                              : '${widget.product.name} adicionado aos favoritos.',
                          )),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}