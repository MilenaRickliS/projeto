import 'package:flutter/material.dart';
import 'package:projeto/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:projeto/providers/cart_provider.dart';
import 'package:projeto/screens/endereco.dart';
import 'package:projeto/providers/auth_provider.dart';
import 'package:projeto/screens/login.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return MainScaffold(
      selectedIndex: 0, 
      body: Scaffold(
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
                    leading: Image.network(
                      cartItem.product.imageLink,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/download.jpg');
                      },
                    ),
                    title: Text(cartItem.product.name),
                    subtitle: Text(
                        'R\$ ${cartItem.product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            cart.decreaseQuantity(cartItem);
                          },
                        ),
                        Text('${cartItem.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            cart.increaseQuantity(cartItem);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: cart.items.isEmpty
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (user == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(fromCart: true),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ConfirmAddressScreen()),
                              );
                            }
                          },
                          child: Text('Finalizar Compra'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          cart.clear();
                        },
                        child: Text('Limpar Carrinho',
                            style: TextStyle(color: Colors.red)),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
