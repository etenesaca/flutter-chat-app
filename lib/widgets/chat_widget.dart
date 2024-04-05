import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String uid;
  final String texto;
  final AnimationController animationController;

  ChatMessage(
      {super.key,
      required this.uid,
      required this.texto,
      required this.animationController});
  final _boxPadding = EdgeInsets.all(8);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: animationController,
        child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animationController, curve: Curves.easeOut),
            child:
                Container(child: uid == '123' ? _myMessage() : _noMyMesage())));
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        padding: _boxPadding,
        decoration: BoxDecoration(
            color: const Color(0xff4D9EF6),
            borderRadius: BorderRadius.circular(20)),
        child: Text(texto, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _noMyMesage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
        padding: _boxPadding,
        decoration: BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius: BorderRadius.circular(20)),
        child: Text(texto, style: TextStyle(color: Colors.black87)),
      ),
    );
  }
}
