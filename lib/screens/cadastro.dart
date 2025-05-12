import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home.dart';
import 'endereco.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';



class RegisterScreen extends StatefulWidget {
  final bool fromCart;
  const RegisterScreen({super.key, this.fromCart = false});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nomeController = TextEditingController();
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final telefoneController = MaskedTextController(mask: '(00) 00000-0000');
  final dataNascimentoController = MaskedTextController(mask: '00/00/0000');
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

  bool isValidCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;
    List<int> numbers = cpf.split('').map(int.parse).toList();

    int calcDigit(List<int> base, int start) {
      int sum = 0;
      for (int i = 0; i < base.length; i++) {
        sum += base[i] * (start - i);
      }
      int mod = sum % 11;
      return mod < 2 ? 0 : 11 - mod;
    }

    int d1 = calcDigit(numbers.sublist(0, 9), 10);
    int d2 = calcDigit(numbers.sublist(0, 10), 11);
    return d1 == numbers[9] && d2 == numbers[10];
  }

  bool isValidDate(String input) {
    try {
      final parts = input.split(RegExp(r'[/\-]'));
      if (parts.length != 3) return false;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);

      if (date.day != day || date.month != month || date.year != year) return false;

      final now = DateTime.now();
      final age = now.year - date.year - ((now.month < month || (now.month == month && now.day < day)) ? 1 : 0);

      return age >= 0 && age <= 120;
    } catch (_) {
      return false;
    }
  }
  final cepFormatter = MaskTextInputFormatter(
    mask: '##.###-###',
    filter: {"#": RegExp(r'[0-9]')},
  );
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



  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
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
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (value) => value != null && value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              TextFormField(
                controller: cpfController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o CPF';
                  if (!isValidCPF(value)) return 'CPF inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: dataNascimentoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Data de Nascimento (dd/mm/aaaa)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a data de nascimento';
                  if (!isValidDate(value)) return 'Data inválida';
                  return null;
                },
              ),
              TextFormField(
                controller: telefoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o telefone' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedGenero,
                decoration: InputDecoration(labelText: 'Gênero'),
                items: generos.map((genero) {
                  return DropdownMenuItem(value: genero, child: Text(genero));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGenero = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione um gênero' : null,
              ),
              TextFormField(
                controller: cepController,
                inputFormatters: [cepFormatter],
                decoration: InputDecoration(labelText: 'CEP'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o CEP';
                  if (!RegExp(r'^\d{2}\.\d{3}-\d{3}$').hasMatch(value)) return 'CEP inválido';
                  return null;
                },
                onFieldSubmitted: (value) => buscarEndereco(value),
              ),
              TextFormField(
                controller: ruaController,
                decoration: InputDecoration(labelText: 'Rua'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe a rua' : null,
              ),
              TextFormField(
                controller: numeroCasaController,
                decoration: InputDecoration(labelText: 'Número'),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe o número' : null,
              ),
              TextFormField(
                controller: cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe a cidade' : null,
              ),
              TextFormField(
                controller: estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Informe o estado' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text("Cadastrar"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
