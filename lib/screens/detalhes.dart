import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/menu.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final cart = Provider.of<Cart>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.product.id);
    return MainScaffold(
            selectedIndex: 0, 
            body: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(widget.product.name, style: TextStyle(color: Colors.white),),
              backgroundColor: Color.fromARGB(255, 1, 88, 10),
              actions: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? '${widget.product.name} removido dos favoritos.'
                              : '${widget.product.name} adicionado aos favoritos.',
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.white,),
                  onPressed: () {
                    cart.addToCart(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.name} foi adicionado ao carrinho!'),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: LayoutBuilder(
              builder: (ctx, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: widget.product.imageLink,
                        child: Image.network(
                          widget.product.imageLink,
                          height: screenHeight * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/download.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.product.brand,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'R\$ ${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 212, 51, 91), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(16),
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 161, 187),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: _expanded ? constraints.maxHeight * 0.4 : 100,
                            child: SingleChildScrollView(
                              physics: _expanded ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                              child: Text(
                                widget.product.description.isNotEmpty
                                    ? widget.product.description
                                    : "Sem descrição disponível.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ),
          );
  }
}
