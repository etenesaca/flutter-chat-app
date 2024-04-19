import 'package:chat/global/environment.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/models.dart';
import 'package:chat/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final resp = await http.get(
      Uri.parse('${Environment.apiUrl}/mensajes/?de=$usuarioId'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      },
    );
    if (resp.statusCode == 200) {
      return mensajesResponseFromJson(resp.body).mensajes;
    } else {
      return [];
    }
  }
}
