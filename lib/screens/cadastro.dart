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

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Cadastro",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 1, 88, 10),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Nome
                  TextFormField(
                    controller: nomeController,
                    decoration: buildInputDecoration('Nome'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                  SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: buildInputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe o email';
                      if (!value.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Senha
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: buildInputDecoration('Senha'),
                    validator: (value) =>
                        value != null && value.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  SizedBox(height: 16),

                  // CPF
                  TextFormField(
                    controller: cpfController,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration('CPF'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe o CPF';
                      if (!isValidCPF(value)) return 'CPF inválido';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Data nascimento
                  TextFormField(
                    controller: dataNascimentoController,
                    keyboardType: TextInputType.number,
                    decoration:
                        buildInputDecoration('Data de Nascimento (dd/mm/aaaa)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a data de nascimento';
                      }
                      if (!isValidDate(value)) return 'Data inválida';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Telefone
                  TextFormField(
                    controller: telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: buildInputDecoration('Telefone'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o telefone' : null,
                  ),
                  SizedBox(height: 16),

                  // Gênero
                  DropdownButtonFormField<String>(
                    value: selectedGenero,
                    decoration: buildInputDecoration('Gênero'),
                    items: generos
                        .map((genero) =>
                            DropdownMenuItem(value: genero, child: Text(genero)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenero = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecione um gênero' : null,
                  ),
                  SizedBox(height: 16),

                  // CEP
                  TextFormField(
                    controller: cepController,
                    inputFormatters: [cepFormatter],
                    decoration: buildInputDecoration('CEP'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe o CEP';
                      if (!RegExp(r'^\d{2}\.\d{3}-\d{3}$').hasMatch(value)) {
                        return 'CEP inválido';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) => buscarEndereco(value),
                  ),
                  SizedBox(height: 16),

                  // Rua
                  TextFormField(
                    controller: ruaController,
                    decoration: buildInputDecoration('Rua'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe a rua' : null,
                  ),
                  SizedBox(height: 16),

                  // Número
                  TextFormField(
                    controller: numeroCasaController,
                    decoration: buildInputDecoration('Número'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o número' : null,
                  ),
                  SizedBox(height: 16),

                  // Cidade
                  TextFormField(
                    controller: cidadeController,
                    decoration: buildInputDecoration('Cidade'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe a cidade' : null,
                  ),
                  SizedBox(height: 16),

                  // Estado
                  TextFormField(
                    controller: estadoController,
                    decoration: buildInputDecoration('Estado'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s]")),
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe o estado' : null,
                  ),

                  SizedBox(height: 24),

                                const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 88, 10),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: const Text(
                    "Cadastrar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
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

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => widget.fromCart
                                ? ConfirmAddressScreen()
                                : HomeScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao cadastrar: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      )
      )
    );
  }
}
