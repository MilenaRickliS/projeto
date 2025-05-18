import 'package:flutter/material.dart';
import 'package:projeto/widgets/menu.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar produtos: $e")),
      );
      setState(() => _isLoading = false);
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatch = product.name.toLowerCase().contains(query);
        final priceMatch = double.tryParse(query) != null &&
            product.price != null &&
            product.price! <= double.parse(query);
        return nameMatch || priceMatch;
      }).toList();
    });
  }

@override
Widget build(BuildContext context) {
  return MainScaffold(
    selectedIndex: 2,
    appBar: AppBar(
      title: const Text(
        "Pesquisar Produtos",
        style: TextStyle(color: Color.fromARGB(255, 1, 88, 10)),
      ),
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 1, 88, 10)),
      backgroundColor: Colors.white,
      elevation: 1,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Pesquisar por nome ou preço",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 1, 88, 10), 
                  width: 2,
                ),
              ),
              floatingLabelStyle: const TextStyle(
                color: Color.fromARGB(255, 1, 88, 10), 
              ),
            ),
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : _filteredProducts.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mood_bad,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum produto encontrado.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (ctx, i) =>
                            ProductItem(product: _filteredProducts[i]),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                      ),
                    ),
        ],
      ),
    ),
  
  );
}

  }

