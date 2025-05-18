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
          title: Text('Pedido #${pedido['uidPedido']}', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 1, 88, 10),
          centerTitle: true,
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Total
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'R\$ ${pedido['total']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 1, 88, 10)),
                      ),
                    ],
                  ),
                ),
              ),

              // Forma de pagamento
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Color.fromARGB(255, 1, 88, 10)),
                  title: const Text(
                    'Forma de Pagamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(pedido['formaPagamento'] ?? ''),
                ),
              ),

              // Endereço de entrega
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Color.fromARGB(255, 1, 88, 10)),
                  title: const Text(
                    'Endereço de Entrega',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${pedido['rua'] ?? ''}, ${pedido['numeroCasa'] ?? ''} - ${pedido['cidade'] ?? ''}/${pedido['estado'] ?? ''}',
                    style: const TextStyle(height: 1.3),
                  ),
                ),
              ),

              // Itens do pedido
              Text(
                'Itens do Pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 88, 10),
                ),
              ),
              const SizedBox(height: 8),

              ...itens.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 30, end: 0), 
                  duration: Duration(milliseconds: 900 + index * 100),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: 1 - (value / 30),
                      child: Transform.translate(
                        offset: Offset(0, value),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(
                        item['nome'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Quantidade: ${item['quantidade']}'),
                      trailing: Text(
                        'R\$ ${item['preco']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 1, 88, 10),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
