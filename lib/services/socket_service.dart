import 'package:chat/global/environment.dart';
import 'package:chat/services/services.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offlline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  dynamic get serverStatus => _serverStatus;
  IO.Socket get socket => _socket!;

  get emit => _socket!.emit;
  get listen => _socket!.on;

  void connect() async {
    // Obtener el token del usario conectado
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
        Environment.SocketURl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            //.disableAutoConnect() // disable auto-connection
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token})
            .build());
    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.Offlline;
      notifyListeners();
    });

    listen('nuevo-mensaje', (payload) {
      print('Nuevo mensaje recibido');
      print('Nombre: ${payload['nombre']}');
      print(payload.containsKey('mensaje')
          ? 'Mensaje: ${payload['mensaje']}'
          : '--No hay mensaje--');
    });
  }

  void disconnect() {
    _socket!.disconnect();
  }
}
