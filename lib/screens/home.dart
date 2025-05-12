import 'package:flutter/material.dart';
import 'package:projeto/widgets/menu.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import 'package:projeto/screens/carrinho.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_lib;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return MainScaffold(
      selectedIndex: 0,
      body: Column(
        children: [
          AppBar(title: Icon(Icons.storefront_sharp, color: const Color.fromARGB(255, 1, 88, 10), size: 28),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: const Color.fromARGB(255, 1, 88, 10), size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/pesquisa'); 
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: const Color.fromARGB(255, 1, 88, 10), size: 28),
              onPressed: () {
                Navigator.pushNamed(context, '/favoritos'); 
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: const Color.fromARGB(255, 1, 88, 10), size: 28),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ],
        ),
        const Divider(height: 1, color: Color.fromARGB(255, 206, 205, 205)),
        carousel_lib.CarouselSlider(
        options: carousel_lib.CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayInterval: Duration(seconds: 3),
        ),
        items: [
          'assets/slide1.jpg',
          'assets/slide2.jpg',
          'assets/slide3.jpg',
          'assets/slide4.jpg',
        ].map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            },
          );
        }).toList(),
      ),
        Expanded(
          child: FutureBuilder(
            future: _productsFuture,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar produtos'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: productProvider.products.length,
                itemBuilder: (ctx, i) => ProductItem(product: productProvider.products[i]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              );
            },
          ), 
          ),
        ],
      ),
    );
  }
}
