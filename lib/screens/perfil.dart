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
      Future.microtask(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    void showEditDialog() {
      final nomeController = TextEditingController(text: user.nome);
      final telefoneController = TextEditingController(text: user.telefone);
      final cepController = TextEditingController(text: user.cep);
      final ruaController = TextEditingController(text: user.rua);
      final numeroCasaController = TextEditingController(text: user.numeroCasa);
      final cidadeController = TextEditingController(text: user.cidade);
      final estadoController = TextEditingController(text: user.estado);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Editar Perfil'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller: nomeController, label: 'Nome'),
                _buildTextField(controller: telefoneController, label: 'Telefone'),
                _buildTextField(controller: cepController, label: 'CEP'),
                _buildTextField(controller: ruaController, label: 'Rua'),
                _buildTextField(controller: numeroCasaController, label: 'Número'),
                _buildTextField(controller: cidadeController, label: 'Cidade'),
                _buildTextField(controller: estadoController, label: 'Estado'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 1, 88, 10)),),
            ),
            ElevatedButton(
              onPressed: () async {
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

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
      ),
    );
  }

  static const TextStyle _labelStyle = TextStyle(fontSize: 16, height: 1.5);
  static const TextStyle _labelStyleBold = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
}
