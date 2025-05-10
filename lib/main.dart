import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart'; 
import 'providers/cart_provider.dart'; 
import 'providers/favorites_provider.dart';
import 'providers/auth_provider.dart'; 
import 'package:projeto/screens/favoritos.dart'; 
import 'screens/home.dart'; 
import 'screens/carrinho.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()), 
        ChangeNotifierProvider(create: (context) => ProductProvider()), 
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        // ChangeNotifierProvider(create: (context) => AuthProvider()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Maquiagem',
      theme: ThemeData(
        primarySwatch: Colors.pink, 
        visualDensity: VisualDensity.adaptivePlatformDensity, 
      ),
      home: HomeScreen(), 
      debugShowCheckedModeBanner: false, 
      routes: {        
        CartScreen.routeName: (context) => const CartScreen(), 
        '/favoritos': (context) => const FavoritesScreen(),
      },
    );
  }
}
