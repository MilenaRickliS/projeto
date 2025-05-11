class UserModel {
  final String uid;
  final String email;
  final String nome;
  final String cpf;
  final String dataNascimento;
  final String telefone;
  final String genero;
  final String cep;
  final String rua;
  final String numeroCasa;
  final String cidade;
  final String estado;

  UserModel({
    required this.uid,
    required this.email,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.genero,
    required this.cep,
    required this.rua,
    required this.numeroCasa,
    required this.cidade,
    required this.estado,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nome: map['nome'],
      cpf: map['cpf'],
      dataNascimento: map['dataNascimento'],
      telefone: map['telefone'],
      genero: map['genero'],
      cep: map['cep'],
      rua: map['rua'],
      numeroCasa: map['numeroCasa'],
      cidade: map['cidade'],
      estado: map['estado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'genero': genero,
      'cep': cep,
      'rua': rua,
      'numeroCasa': numeroCasa,
      'cidade': cidade,
      'estado': estado,
    };
  }
}
