import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home.dart';
import 'cadastro.dart';
import 'endereco.dart';

class LoginScreen extends StatefulWidget {
  final bool fromCart;
  const LoginScreen({super.key,  this.fromCart = false});
  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Senha'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Entrar"),
              onPressed: () async {
                await authProvider.signIn(
                  emailController.text,
                  passwordController.text,
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
              },
            ),
            TextButton(
              child: Text("Não tem conta? Cadastre-se"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen(fromCart: widget.fromCart)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
