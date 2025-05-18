import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    if (_products.isNotEmpty) return;
    _products = await ApiService.fetchProducts();
    notifyListeners();
  }

}