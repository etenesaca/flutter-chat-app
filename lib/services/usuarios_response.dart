import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          });
      if (resp.statusCode == 200) {
        final usuarios_resp = usuariosResponseFromJson(resp.body);
        return usuarios_resp.usuarios;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
