import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'screens/favoritos.dart';
import 'screens/home.dart';
import 'screens/carrinho.dart';
import 'screens/login.dart';
import 'screens/categorias.dart';
import 'screens/pedidos.dart';  
import 'screens/endereco.dart';  
import 'screens/pagamento.dart';  
import 'screens/confirmar.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()), 
        ChangeNotifierProvider(create: (context) => ProductProvider()), 
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()), 
        ChangeNotifierProvider(create: (context) => OrderProvider()),
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
        '/filtro': (context) => const FilterScreen(),
        '/login': (context) => const LoginScreen(),
        '/orders': (context) => _checkAuth(context, OrdersScreen()),  
        '/confirm-address': (context) => _checkAuth(context, ConfirmAddressScreen()),  
        '/payment-method': (context) => _checkAuth(context, PaymentMethodScreen()),  
        '/confirm-order': (context) => _checkAuth(context, ConfirmOrderScreen()),  
      },
    );
  }

  // Função para proteger a rota
  Widget _checkAuth(BuildContext context, Widget screen) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.user == null) {
      return LoginScreen();
    } else {
      return screen;
    }
  }
}
