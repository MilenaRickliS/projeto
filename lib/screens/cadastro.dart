import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home.dart';
import 'endereco.dart';

class RegisterScreen extends StatefulWidget {
  final bool fromCart;
  const RegisterScreen({super.key, this.fromCart = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final telefoneController = TextEditingController();
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroCasaController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final passwordController = TextEditingController();

  String? selectedGenero;

  final List<String> generos = [
    'Feminino',
    'Masculino',
    'Prefiro não informar',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            TextField(controller: cpfController, decoration: InputDecoration(labelText: 'CPF')),
            TextField(controller: dataNascimentoController, decoration: InputDecoration(labelText: 'Data de Nascimento')),
            TextField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telefone')),

            DropdownButtonFormField<String>(
              value: selectedGenero,
              decoration: InputDecoration(labelText: 'Gênero'),
              items: generos.map((genero) {
                return DropdownMenuItem(
                  value: genero,
                  child: Text(genero),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGenero = value;
                });
              },
            ),

            TextField(controller: cepController, decoration: InputDecoration(labelText: 'CEP')),
            TextField(controller: ruaController, decoration: InputDecoration(labelText: 'Rua')),
            TextField(controller: numeroCasaController, decoration: InputDecoration(labelText: 'Número')),
            TextField(controller: cidadeController, decoration: InputDecoration(labelText: 'Cidade')),
            TextField(controller: estadoController, decoration: InputDecoration(labelText: 'Estado')),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Cadastrar"),
              onPressed: () async {
                try {
                  await authProvider.register(
                    email: emailController.text,
                    password: passwordController.text,
                    nome: nomeController.text,
                    cpf: cpfController.text,
                    dataNascimento: dataNascimentoController.text,
                    telefone: telefoneController.text,
                    genero: selectedGenero ?? '',
                    cep: cepController.text,
                    rua: ruaController.text,
                    numeroCasa: numeroCasaController.text,
                    cidade: cidadeController.text,
                    estado: estadoController.text,
                  );

                  if (!mounted) return;

                  if (widget.fromCart) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ConfirmAddressScreen()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao cadastrar: $e')),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
