import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho de Compras'),
      ),
      body: cart.items.isEmpty
          ? Center(child: Text('Seu carrinho está vazio.'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                final cartItem = cart.items[index];
                return ListTile(
                  leading: Image.network(cartItem.product.imageLink,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/download.jpg'
                    );
                  },
                  ),
                  title: Text(cartItem.product.name),
                  subtitle: Text('R\$ ${cartItem.product.price.toStringAsFixed(2)}'),
                  trailing: Column(
                    children: [
                      Text('x${cartItem.quantity}'),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          cart.removeFromCart(cartItem);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
  
                      cart.clear();
                    },
                    child: Text('Finalizar Compra'),
                  ),
                ],
              ),
            ),
    );
  }
}
