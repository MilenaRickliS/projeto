import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = result.user!.uid;

    final doc = await _firestore.collection('usuarios').doc(uid).get();
    _user = UserModel.fromMap(doc.data()!);

    notifyListeners();
  }


  Future<void> register({
    required String email,
    required String password,
    required String nome,
    required String cpf,
    required String dataNascimento,
    required String telefone,
    required String genero,
    required String cep,
    required String rua,
    required String numeroCasa,
    required String cidade,
    required String estado,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      await _firestore.collection('usuarios').doc(uid).set({
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
        'criadoEm': DateTime.now(),
      });

      final doc = await _firestore.collection('usuarios').doc(uid).get();
      _user = UserModel.fromMap(doc.data()!);
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  void updateUserAddress(String rua, String numero, String cidade, String estado) async {
    if (_user != null) {
      
      _user!.rua = rua;
      _user!.numeroCasa = numero;
      _user!.cidade = cidade;
      _user!.estado = estado;
      
      
      await _firestore.collection('usuarios').doc(_user!.uid).update({
        'rua': rua,
        'numeroCasa': numero,
        'cidade': cidade,
        'estado': estado,
      });

      notifyListeners(); 
    }
  }

}
