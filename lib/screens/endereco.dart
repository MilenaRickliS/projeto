import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';

class ConfirmAddressScreen extends StatefulWidget {
  const ConfirmAddressScreen({super.key});

  @override
  ConfirmAddressScreenState createState() => ConfirmAddressScreenState();
}

class ConfirmAddressScreenState extends State<ConfirmAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final cepController = TextEditingController();
  final cepFormatter = MaskTextInputFormatter(
    mask: '##.###-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      cepController.text = user.cep;
      ruaController.text = user.rua;
      numeroController.text = user.numeroCasa;
      cidadeController.text = user.cidade;
      estadoController.text = user.estado;
    }
  }

  @override
  void dispose() {
    cepController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  Future<void> buscarEndereco(String cep) async {
    final cepSanitizado = cep.replaceAll(RegExp(r'\D'), '');
    final viaCepSearchCep = ViaCepSearchCep();

    try {
      final result = await viaCepSearchCep.searchInfoByCep(cep: cepSanitizado);
      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao buscar CEP: ${error.toString()}')),
          );
        },
        (info) {
          setState(() {
            ruaController.text = info.logradouro ?? '';
            cidadeController.text = info.localidade ?? '';
            estadoController.text = info.uf ?? '';
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Endereço'),
        backgroundColor: const Color.fromARGB(255, 1, 88, 10),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),        
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cepController,
                inputFormatters: [cepFormatter],
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('CEP', icon: Icons.location_on),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o CEP';
                  if (!RegExp(r'^\d{2}\.\d{3}-\d{3}$').hasMatch(value)) return 'CEP inválido';
                  return null;
                },
                onFieldSubmitted: buscarEndereco,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ruaController,
                decoration: _inputDecoration('Rua', icon: Icons.streetview),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe a rua' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: numeroController,
                decoration: _inputDecoration('Número', icon: Icons.home),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => value == null || value.isEmpty ? 'Informe o número' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cidadeController,
                decoration: _inputDecoration('Cidade', icon: Icons.location_city),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe a cidade' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: estadoController,
                decoration: _inputDecoration('Estado', icon: Icons.map),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe o estado' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color.fromARGB(255, 1, 88, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text('Próximo', style: TextStyle(color: Colors.white, fontSize: 16)),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      authProvider.updateUserAddress(
                        cepController.text,
                        ruaController.text,
                        numeroController.text,
                        cidadeController.text,
                        estadoController.text,
                      );
                      Navigator.pushNamed(context, '/payment-method');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
