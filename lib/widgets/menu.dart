import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/categorias.dart';
import '../screens/pesquisa.dart';
import '../screens/pedidos.dart';
import '../screens/login.dart';
import '../screens/perfil.dart';
import 'package:provider/provider.dart';
import 'package:projeto/providers/auth_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final PreferredSizeWidget? appBar;

  const MainScaffold({super.key, required this.body, required this.selectedIndex, this.appBar});

  void _onItemTapped(BuildContext context, int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.user != null;
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
        if (isLoggedIn) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrdersScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
        break;
      case 4:
        if (isLoggedIn) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: const Color.fromARGB(255, 0, 114, 19),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          const BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categorias'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
          const BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pedidos'),
          BottomNavigationBarItem(
            icon: Icon(
              Provider.of<AuthProvider>(context).user != null ? Icons.person : Icons.login,
            ),
            label: Provider.of<AuthProvider>(context).user != null ? 'Perfil' : 'Login',
          ),
        ],

      ),
    );
  }
}
