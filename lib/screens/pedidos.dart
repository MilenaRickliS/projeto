import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dart:developer';
import 'detalhes_pedidos.dart'; 
import '../widgets/menu.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return MainScaffold(
      selectedIndex: 0, 
      body: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      );
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('pedidos')
          .where('uidCliente', isEqualTo: user.uid)
          .get(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainScaffold(
          selectedIndex: 0, 
          body: Scaffold(
            appBar: AppBar(title: Text('Meus Pedidos')),
            body: Center(child: CircularProgressIndicator()),
          ),
          );
        }

        if (snapshot.hasError) {
          return MainScaffold(
            selectedIndex: 0, 
            body: Scaffold(
            appBar: AppBar(title: Text('Meus Pedidos')),
            body: Center(child: Text('Erro ao carregar pedidos')),
            ),
          );
        }

        final pedidos = snapshot.data?.docs ?? [];
        log("Pedidos carregados: $pedidos");

        if (pedidos.isEmpty) {
          return MainScaffold(
          selectedIndex: 0, 
          body: Scaffold(
            appBar: AppBar(title: Text('Meus Pedidos')),
            body: Center(child: Text('Nenhum pedido encontrado')),
          ),
          );
        }

        return MainScaffold(
          selectedIndex: 0, 
          body: Scaffold(
          appBar: AppBar(title: Text('Meus Pedidos')),
          body: ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (ctx, index) {
              final pedidoData = pedidos[index].data() as Map<String, dynamic>;
              final total = pedidoData['total'];
              final formaPagamento = pedidoData['formaPagamento'];
              return ListTile(
                title: Text('Pedido #${pedidoData['uidPedido']}'),
                subtitle: Text('Total: R\$ $total\nForma de Pagamento: $formaPagamento'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(pedido: pedidoData),
                    ),
                  );
                },
              );
            },
          ),
          ),
        );
      },
    );

  }
}
