import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home.dart';
import 'package:projeto/screens/carrinho.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        
      ],
      child: MaterialApp(
        title: 'Catálogo de Maquiagem',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    );
  }
}
