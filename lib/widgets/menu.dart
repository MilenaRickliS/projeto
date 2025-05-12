import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/categorias.dart';
import '../screens/pesquisa.dart';
import '../screens/pedidos.dart';
import '../screens/login.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const MainScaffold({super.key, required this.body, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FilterScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrdersScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorias'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
        ],
      ),
    );
  }
}
