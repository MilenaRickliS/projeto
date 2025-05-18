import 'package:flutter/material.dart';
import 'package:projeto/models/product.dart';
import 'package:projeto/models/cart.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    var existingCartItem = _items.firstWhere(
      (item) => item.product.name == product.name,
      orElse: () => CartItem(product: product),
    );

    if (_items.contains(existingCartItem)) {
      existingCartItem.quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      removeFromCart(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
