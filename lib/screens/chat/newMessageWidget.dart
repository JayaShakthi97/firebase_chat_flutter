import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();
  final String chatId;
  final bool disabled;
  final Function(String, String) onSendMessage;

  NewMessage({Key key, this.onSendMessage, this.disabled, this.chatId}) : super(key: key);

  void _sendMessage() {
    onSendMessage(chatId, _messageController.text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          readOnly: disabled,
        )),
        IconButton(
            icon: Icon(Icons.send),
            onPressed: disabled ? null : () => _sendMessage()),
      ],
    );
  }
}
