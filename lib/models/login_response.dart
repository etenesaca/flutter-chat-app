// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/models.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool ok;
  Usuario? usuario;
  String? token;
  String? msg;
  String? errors;

  LoginResponse({
    required this.ok,
    required this.usuario,
    required this.token,
    required this.msg,
    required this.errors,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: json.containsKey('usuario')
            ? Usuario.fromJson(json["usuario"])
            : null,
        token: json.containsKey("token") ? json["token"] : null,
        msg: json.containsKey("msg") ? json["msg"] : null,
        errors: json.containsKey("errors") ? '${json["errors"]}' : null,
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario != null ? usuario!.toJson() : '',
        "token": token,
        "msg": msg,
      };
}
