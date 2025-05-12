import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import 'home.dart';
import 'cadastro.dart';
import 'endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final formKey = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o email';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value != null && value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Entrar"),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      await authProvider.signIn(
                        emailController.text.trim(),
                        passwordController.text.trim(),
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
                    } on FirebaseAuthException catch (e) {
                      String message;

                      switch (e.code) {
                        case 'user-not-found':
                          message = 'Email não cadastrado.';
                          break;
                        case 'wrong-password':
                          message = 'Senha incorreta.';
                          break;
                        case 'invalid-email':
                          message = 'Email inválido.';
                          break;
                        default:
                          message = 'Erro ao fazer login: ${e.message}';
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro inesperado: $e')),
                      );
                    }
                  }
                }

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
      ),
    );
  }
}
