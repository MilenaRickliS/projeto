import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://makeup-api.herokuapp.com/api/v1/products.json'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}