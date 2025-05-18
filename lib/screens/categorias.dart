import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'categorias_produtos.dart';
import '../widgets/menu.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    final categories = products.map((p) => p.productType).toSet().toList();

    return MainScaffold(
      selectedIndex: 1, 
      appBar: AppBar(
        title: const Text(
          'Filtrar por Categoria',
          style: TextStyle(color: Color.fromARGB(255, 1, 88, 10)),
        ),
        backgroundColor: Colors.grey[200], 
      ),
      body: Container(
        color: Colors.grey[200], 
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: categories.length,
          itemBuilder: (ctx, index) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                title: Text(
                  categories[index],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 88, 10),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 1, 88, 10),
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FilteredProductsScreen(category: categories[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );

  }
}
