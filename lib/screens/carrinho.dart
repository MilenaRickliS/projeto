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
          backgroundColor: const Color.fromARGB(255, 1, 88, 10),
          title: const Text(
            'Carrinho de Compras',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: cart.items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Seu carrinho está vazio.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () => cart.clear(),
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 255, 255)),
                      label: const Text(
                        'Limpar Carrinho',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                       
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 121, 5, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (ctx, index) {
                      final cartItem = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              cartItem.product.imageLink,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/download.jpg',
                                  width: 60,
                                  height: 60,
                                );
                              },
                            ),
                          ),
                          title: Text(
                            cartItem.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'R\$ ${cartItem.product.price.toStringAsFixed(2)}',
                          ),
                          trailing: SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.decreaseQuantity(cartItem),
                                  color: Colors.red,
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.increaseQuantity(cartItem),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      
                    },
                  ),
                ),
              ],
            ),

        bottomNavigationBar: cart.items.isEmpty
            ? const SizedBox.shrink()
            : Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 1, 88, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (user == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen(fromCart: true),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ConfirmAddressScreen(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.shopping_bag, color: Colors.white,),
                        label: const Text('Finalizar Compra', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
