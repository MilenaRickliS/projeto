import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';
import 'package:logger/logger.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> salvarPedido(OrderModel pedido) async {
    try {
      await _firestore.collection('pedidos').doc(pedido.uidPedido).set(pedido.toMap());
      notifyListeners();
    } catch (e) {
      _logger.e('Erro ao salvar pedido: $e');
      rethrow; 
    }
  }

}

