import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import 'home.dart';
import 'cadastro.dart';
import 'endereco.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final bool fromCart;
  const LoginScreen({super.key, this.fromCart = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 1, 88, 10),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white,),
            tooltip: 'Voltar para a tela inicial',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bem-vindo(a)! Faça login para continuar",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Color.fromARGB(255, 1, 88, 10),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                       focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 1, 88, 10), 
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 1, 88, 10), 
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe o email';
                      if (!value.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 1, 88, 10), 
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 1, 88, 10), 
                      ),
                    ),
                    validator: (value) => value != null && value.length < 6
                        ? 'Mínimo 6 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 1, 88, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Entrar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem conta? "),
                      TextButton(
                        child: Text(
                          "Cadastre-se",
                          style: TextStyle(color: Color.fromARGB(255, 1, 88, 10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(fromCart: widget.fromCart),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
