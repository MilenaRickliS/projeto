import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login.dart';
import '../widgets/menu.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:search_cep/search_cep.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();

}

class ProfileScreenState extends State<ProfileScreen> {
  String endereco = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    void showEditDialog() {
      final formKey = GlobalKey<FormState>();

      final nomeController = TextEditingController(text: user.nome);
      final telefoneController = MaskedTextController(mask: '(00) 00000-0000');
      final cepController = TextEditingController(text: user.cep);
      final ruaController = TextEditingController(text: user.rua);
      final numeroCasaController = TextEditingController(text: user.numeroCasa);
      final cidadeController = TextEditingController(text: user.cidade);
      final estadoController = TextEditingController(text: user.estado);

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

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Editar Perfil'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildValidatedTextField(
                    controller: nomeController,
                    label: 'Nome',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Nome obrigatório';
                      if (!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(value)) return 'Nome inválido, é permitido apenas letras!';
                      return null;
                    },
                  ),
                  _buildValidatedTextField(
                    controller: telefoneController,
                    label: 'Telefone',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Telefone obrigatório';
                      
                      return null;
                    },
                  ),
                  _buildValidatedTextField(
                    controller: cepController,
                    label: 'CEP',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'CEP obrigatório';
                      
                      return null;
                    },
                    onFieldSubmitted: (value) => buscarEndereco(value),
                    inputFormatters: [cepFormatter],
                  ),
                  _buildValidatedTextField(
                    controller: ruaController,
                    label: 'Rua',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Rua obrigatória';
                      if (!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(value)) return 'Nome rua inválido, é permitido apenas letras!';
                      return null; 
                    },
                                  
                  ),
                  _buildValidatedTextField(
                    controller: numeroCasaController,
                    label: 'Número',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Número obrigatório';
                      if (!RegExp(r"^\d+$").hasMatch(value)) return 'Número inválido, é permitido apenas números!';
                      return null;
                    },
                  ),
                  _buildValidatedTextField(
                    controller: cidadeController,
                    label: 'Cidade',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Cidade obrigatória';
                      if (!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(value)) return 'Cidade inválida,  é permitido apenas letras!';
                      return null;
                    },
                  ),
                  _buildValidatedTextField(
                    controller: estadoController,
                    label: 'Estado',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Estado obrigatório';
                      if (!RegExp(r"^[A-Za-zÀ-ÿ\s]+$").hasMatch(value)) return 'Estado inválido, é permitido apenas letras!';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 1, 88, 10))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await authProvider.updateUser(
                    nome: nomeController.text.trim(),
                    telefone: telefoneController.text.trim(),
                    cep: cepController.text.trim(),
                    rua: ruaController.text.trim(),
                    numeroCasa: numeroCasaController.text.trim(),
                    cidade: cidadeController.text.trim(),
                    estado: estadoController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 1, 88, 10),
              ),
              child: const Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }


    return MainScaffold(
      selectedIndex: 4,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil do Usuário', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 1, 88, 10),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: showEditDialog,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromARGB(255, 0, 114, 19),
                  child: Text(
                    user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoTile('Nome', user.nome),
              _buildInfoTile('Email', user.email),
              _buildInfoTile('CPF', user.cpf),
              _buildInfoTile('Data de Nascimento', user.dataNascimento),
              _buildInfoTile('Telefone', user.telefone),
              _buildInfoTile('Gênero', user.genero),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text('Endereço:', style: _labelStyleBold),
              _buildInfoTile('Rua', '${user.rua}, ${user.numeroCasa}'),
              _buildInfoTile('Cidade/Estado', '${user.cidade} - ${user.estado}'),
              _buildInfoTile('CEP', user.cep),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Sair', style: TextStyle(color: Colors.white)),
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

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$title: $value', style: _labelStyle),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted, 
    List<TextInputFormatter>? inputFormatters, 
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,  
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 1, 88, 10),
              width: 2,
            ),
          ),
          floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 1, 88, 10)),
        ),
      ),
    );
  }



  static const TextStyle _labelStyle = TextStyle(fontSize: 16, height: 1.5);
  static const TextStyle _labelStyleBold = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
}
