import 'package:flutter/material.dart';
import 'package:projeto/widgets/menu.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      selectedIndex: 1,
      body: Center(child: Text("Tela de Pesquisa")),
    );
  }
}
