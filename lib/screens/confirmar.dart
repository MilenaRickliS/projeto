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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    String? paymentMethod = ModalRoute.of(context)?.settings.arguments as String?;

    final total = cart.items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.green.withAlpha(230),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Endereço de Entrega',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('${user.rua}, ${user.numeroCasa}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('${user.cidade} - ${user.estado}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 20),
                      Text(
                        'Forma de Pagamento',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(paymentMethod ?? 'Desconhecida',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Itens do Carrinho',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...cart.items.map((item) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[50],
                    child: Text(
                      '${item.quantity}x',
                      style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text('R\$ ${item.product.price.toStringAsFixed(2)}'),
                  trailing: Text(
                    'R\$ ${(item.product.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        )),
                Text('R\$ ${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        )),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Confirmar Pedido', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (cart.items.isEmpty) return;

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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
