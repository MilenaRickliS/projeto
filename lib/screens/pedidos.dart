import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dart:developer';
import 'detalhes_pedidos.dart'; 
import '../widgets/menu.dart';
import 'home.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return MainScaffold(
        selectedIndex: 0,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return MainScaffold(
      selectedIndex: 0,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Pedidos', style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 1, 88, 10),
          elevation: 2,
          centerTitle: true,
          actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white,),
            tooltip: 'Voltar para a tela inicial',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
        ],
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('pedidos')
              .where('uidCliente', isEqualTo: user.uid)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar pedidos'));
            }

            final pedidos = snapshot.data?.docs ?? [];
            log("Pedidos carregados: $pedidos");

            if (pedidos.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum pedido encontrado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pedidos.length,
              itemBuilder: (ctx, index) {
                final pedidoData = pedidos[index].data() as Map<String, dynamic>;
                final total = pedidoData['total'];
                final formaPagamento = pedidoData['formaPagamento'];
                final uidPedido = pedidoData['uidPedido'] ?? '---';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    title: Text(
                      'Pedido #$uidPedido',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 1, 88, 10),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total: R\$ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Forma de Pagamento: $formaPagamento',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 1, 88, 10),
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(pedido: pedidoData),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
