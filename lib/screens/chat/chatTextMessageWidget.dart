import 'package:chat_app/models/chatMessage.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isSent;

  const TextMessage({Key key, @required this.chatMessage, this.isSent = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: isSent
          ? Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                chatMessage.message,
                textAlign: TextAlign.right,
              ),
            )
          : Container(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                chatMessage.message,
                textAlign: TextAlign.left,
              ),
            ),
    );
  }
}
