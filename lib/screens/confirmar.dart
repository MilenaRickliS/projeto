import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import 'package:uuid/uuid.dart';


class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  ConfirmOrderScreenState createState() => ConfirmOrderScreenState();
}

class ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }

    String? paymentMethod = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: Text('Confirmar Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Endereço: ${user?.rua}, ${user?.numeroCasa}, ${user?.cidade} - ${user?.estado}'),
            SizedBox(height: 20),
            Text('Forma de Pagamento: $paymentMethod'),
            SizedBox(height: 20),
            Text('Itens do Carrinho:'),
            ...cart.items.map((cartItem) {
              return ListTile(
                title: Text(cartItem.product.name),
                subtitle: Text('Quantidade: ${cartItem.quantity} - R\$ ${cartItem.product.price.toStringAsFixed(2)}'),
              );
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (user == null || cart.items.isEmpty) return;  

                final total = cart.items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

                final pedido = OrderModel(
                  uidPedido: const Uuid().v4(),
                  uidCliente: user.uid,
                  itens: cart.items.map((item) => {
                    'nome': item.product.name,
                    'preco': item.product.price,
                    'quantidade': item.quantity,
                  }).toList(),
                  formaPagamento: paymentMethod ?? 'Desconhecido',
                  rua: user.rua,
                  numeroCasa: user.numeroCasa,
                  cidade: user.cidade,
                  estado: user.estado,
                  total: total,
                );

                final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                try {
                  await orderProvider.salvarPedido(pedido);
                  cart.clear(); 
                 
                  if (!mounted) return; 
                  
                  Navigator.pushReplacementNamed(context, '/orders');
                } catch (e) {
                 
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Erro ao confirmar pedido: $e'),
                  ));
                }
              },
              child: Text('Confirmar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
