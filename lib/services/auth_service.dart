import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthService with ChangeNotifier {
  Usuario? usuario;
  // Mostrar errores al crear usuario
  String _registerUserProblems = '';
  String get registerUserProblems => _registerUserProblems;

  // Mostrar errores al hacer login
  String _loginProblems = '';
  String get loginProblems => _loginProblems;

  // Gestion de proceso de autenticación
  bool _autenticando = false;
  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Gestion de proceso de creación del usuario
  bool _creandoUsuario = false;
  bool get creandoUsuario => _autenticando;
  set creandoUsuario(bool valor) {
    _creandoUsuario = valor;
    notifyListeners();
  }

  // Gestión de los token
  final _storage = FlutterSecureStorage();
  static const tokenKey = 'token';

  static Future<String> getToken() async {
    final token = await const FlutterSecureStorage().read(key: tokenKey);
    return token!;
  }

  static Future<void> deleteToken() async {
    await const FlutterSecureStorage().delete(key: tokenKey);
  }

  buildEmail(String email) {
    return email.trim().toLowerCase();
  }

  Future<bool> Login(String email, String password) async {
    final data = {
      'email': buildEmail(email),
      'password': password,
    };

    autenticando = true;
    final uriLogin = Uri.parse('${Environment.apiUrl}/login');
    final Response resp;
    try {
      resp = await http.post(
        uriLogin,
        body: jsonEncode(data),
        headers: {'content-Type': 'Application/json'},
      );
    } catch (e) {
      _loginProblems =
          'Algo salio mal. No pudimos conectarnos a nuestro servidores';
      return false;
    }
    autenticando = false;
    final loginResponse = loginResponseFromJson(resp.body);
    if (resp.statusCode == 200) {
      usuario = loginResponse.usuario;
      saveToken(loginResponse.token!);
      return true;
    } else {
      _loginProblems = loginResponse.msg!;
      return false;
    }
  }

  Future<bool> newUser(String name, String email, String password) async {
    final data = {
      'nombre': name,
      'email': buildEmail(email),
      'password': password,
    };
    // Llamar al webservice de creación del los usuarios
    final uriNew = Uri.parse('${Environment.apiUrl}/login/new');
    final Response resp;
    try {
      resp = await http.post(
        uriNew,
        body: jsonEncode(data),
        headers: {'content-Type': 'Application/json'},
      );
    } catch (e) {
      _registerUserProblems = 'Algo salió mal. No pudimos crear tu cuenta';
      return false;
    }
    // Revisar respuesta del servidor
    final newResponse = loginResponseFromJson(resp.body);
    if (resp.statusCode == 200) {
      usuario = newResponse.usuario;
      saveToken(newResponse.token!);
      return true;
    } else {
      if (newResponse.msg != null) {
        _registerUserProblems = newResponse.msg!;
      } else if (newResponse.errors != null) {
        _registerUserProblems = newResponse.errors!;
      }
      return false;
    }
  }

  Future saveToken(String token) async {
    // Almacenar token en un lugar seguro
    await _storage.write(key: tokenKey, value: token);
  }

  Future logout() async {
    await _storage.delete(key: tokenKey);
  }

  Future<bool> isLogged() async {
    final token = await _storage.read(key: tokenKey);
    print("==========================================");
    print(token);
    print("==========================================");
    if (token == null || token!.isEmpty) {
      return false;
    }
    // Llamar al webservice de creación del los usuarios
    final uriRenew = Uri.parse('${Environment.apiUrl}/login/renew');
    final Response resp;
    try {
      resp = await http.get(
        uriRenew,
        headers: {'content-Type': 'Application/json', 'x-token': token},
      );
    } catch (e) {
      logout();
      return false;
    }
    // Revisar respuesta del servidor
    final renewResponse = loginResponseFromJson(resp.body);
    if (resp.statusCode == 200) {
      usuario = renewResponse.usuario;
      saveToken(renewResponse.token!);
      return true;
    } else {
      logout();
      return false;
    }
  }
}
