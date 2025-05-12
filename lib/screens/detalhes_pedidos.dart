import 'package:flutter/material.dart';
import '../widgets/menu.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pedido;

  const OrderDetailScreen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    final itens = List<Map<String, dynamic>>.from(pedido['itens'] ?? []);

    return MainScaffold(
      selectedIndex: 0, 
      body: Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido #${pedido['uidPedido']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Total: R\$ ${pedido['total']?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Forma de Pagamento: ${pedido['formaPagamento']}'),
            SizedBox(height: 8),
            Text('Endereço de Entrega:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${pedido['rua']}, ${pedido['numeroCasa']} - ${pedido['cidade']}/${pedido['estado']}'),
            Divider(height: 32),
            Text('Itens do Pedido:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...itens.map((item) {
            return ListTile(
              title: Text(item['nome'] ?? ''),
              subtitle: Text('Quantidade: ${item['quantidade']}'),
              trailing: Text('R\$ ${item['preco']?.toStringAsFixed(2) ?? '0.00'}'),
            );
          })
          ],
        ),
      ),
      ),
    );
  }
}
