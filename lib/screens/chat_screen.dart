import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/services.dart';
import 'package:chat/widgets/chat_widget.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'Chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController _txtChatController = new TextEditingController();
  FocusNode _txtChatFocus = new FocusNode();
  List<ChatMessage> messages = [];
  var _estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    // Escuhar evento de mensaje personal
    socketService.socket.on(
      'mensaje-personal',
      (data) {
        _escucharMensaje(data);
      },
    );

    // Cargar el historial de chat
    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await chatService.getChat(usuarioId);
    final history = chat.map((x) => ChatMessage(
        uid: x.de,
        texto: x.mensaje,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..forward()));
    setState(() {
      messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(data) {
    ChatMessage message = ChatMessage(
        uid: data['de'],
        texto: data['mensaje'],
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        ));
    setState(() {
      messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(usuarioPara.nombre.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              Text(usuarioPara.nombre,
                  style: TextStyle(fontSize: 13, color: Colors.black87))
            ],
          )),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int i) => messages[i],
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: _inputchat(),
          )
        ],
      ),
    );
  }

  Widget _inputchat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
                child: TextField(
              controller: _txtChatController,
              onSubmitted: _handleSubmit,
              onChanged: (String text) {
                setState(() {
                  if (text.isNotEmpty) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _txtChatFocus,
            )),
            //Botón enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_txtChatController.text.trim())
                          : null)
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _estaEscribiendo
                                ? () => _handleSubmit(
                                    _txtChatController.text.trim())
                                : null,
                            icon: Icon(Icons.send, color: Colors.blue[400])),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;
    _txtChatFocus.requestFocus();
    _txtChatController.clear();
    // Crear nuevo mensaje
    final newMessage = ChatMessage(
        uid: authService.usuario!.uid,
        texto: texto,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
    if (texto.isEmpty) return;
    // Emitir evento del mensaje
    socketService.emit('mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    // TODO: off del socket
    for (ChatMessage msg in messages) {
      msg.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
