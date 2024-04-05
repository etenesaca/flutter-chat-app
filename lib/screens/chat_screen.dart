import 'dart:io';

import 'package:chat/widgets/chat_widget.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text('JP',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              Text('Juan Perez',
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
        uid: '123',
        texto: texto,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
    if (texto.isEmpty) return;
  }

  @override
  void dispose() {
    // TODO: off del socket
    for (ChatMessage msg in messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}
