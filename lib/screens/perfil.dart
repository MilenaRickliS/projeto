import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login.dart';
import '../widgets/menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      // Caso usuário não esteja logado (por segurança)
      Future.microtask(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MainScaffold(
      selectedIndex: 4,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil do Usuário', style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 1, 88, 10),
          centerTitle: true,
          leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 0, 114, 19),
                child: Text(
                  user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text('Nome: ${user.nome}', style: _labelStyle),
              Text('Email: ${user.email}', style: _labelStyle),
              Text('CPF: ${user.cpf}', style: _labelStyle),
              Text('Data de Nascimento: ${user.dataNascimento}', style: _labelStyle),
              Text('Telefone: ${user.telefone}', style: _labelStyle),
              Text('Gênero: ${user.genero}', style: _labelStyle),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text('Endereço:', style: _labelStyleBold),
              Text('${user.rua}, ${user.numeroCasa}', style: _labelStyle),
              Text('${user.cidade} - ${user.estado}', style: _labelStyle),
              Text('CEP: ${user.cep}', style: _labelStyle),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                icon: const Icon(Icons.logout, color: Colors.white,),
                label: const Text('Sair', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 114, 19),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const TextStyle _labelStyle = TextStyle(fontSize: 16, height: 1.5);
  static const TextStyle _labelStyleBold = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
}
