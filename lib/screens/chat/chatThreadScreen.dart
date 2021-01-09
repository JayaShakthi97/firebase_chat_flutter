import 'package:chat_app/firebaseServices/authService.dart';
import 'package:chat_app/firebaseServices/chatService.dart';
import 'package:chat_app/models/appUser.dart';
import 'package:chat_app/models/chatMessage.dart';
import 'package:chat_app/screens/chat/chatTextMessageWidget.dart';
import 'package:chat_app/screens/chat/newMessageWidget.dart';
import 'package:chat_app/widgets/fullScreenError.dart';
import 'package:chat_app/widgets/fullScreenLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatThreadScreenPayload {
  final AppUser appUser;
  final String chatId;

  ChatThreadScreenPayload(this.appUser, this.chatId);
}

class ChatThreadScreen extends StatefulWidget {
  static const routeName = '/chat-thread';
  final AppUser appUser;
  final String chatId;

  const ChatThreadScreen({Key key, @required this.appUser, this.chatId})
      : super(key: key);

  @override
  _ChatThreadScreenState createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  User _currentUser;
  Future<String> _chatDocId;
  Stream<List<ChatMessage>> _messagesStream;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService.getInstance().getCurrentUser();
    if (widget.chatId != null) {
      _chatDocId = Future(() => widget.chatId);
    } else {
      _chatDocId = ChatService.getInstance()
          .initializeChatRoom(_currentUser.uid, widget.appUser.id);
    }
  }

  void _sendMessage(String chatId, String text) async {
    if (text.isEmpty) return;
    ChatMessage message = ChatMessage(
        message: text,
        contentType: MessageContentType.text,
        fromId: _currentUser.uid,
        toId: widget.appUser.id,
        sentAt: DateTime.now(),
        createdAt: FieldValue.serverTimestamp());
    try {
      await ChatService.getInstance().createMessage(chatId, message);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appUser.displayName)),
      body: FutureBuilder<String>(
          future: _chatDocId,
          builder: (context, chatIdSnapshot) {
            if (chatIdSnapshot.hasError) {
              return Column(
                children: [
                  Expanded(child: FullScreenErrorWidget()),
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey)),
                    child: NewMessage(
                      onSendMessage: _sendMessage,
                      disabled: true,
                    ),
                  ),
                ],
              );
            }
            if (!chatIdSnapshot.hasData) {
              return Column(
                children: [
                  Expanded(child: FullScreenLoadingWidget()),
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey)),
                    child: NewMessage(
                      onSendMessage: _sendMessage,
                      disabled: true,
                    ),
                  ),
                ],
              );
            }
            _messagesStream =
                ChatService.getInstance().getChatMessages(chatIdSnapshot.data);
            return StreamBuilder<List<ChatMessage>>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Column(
                      children: [
                        Expanded(child: FullScreenErrorWidget()),
                        Container(
                          padding: EdgeInsets.only(left: 10, bottom: 2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey)),
                          child: NewMessage(
                            onSendMessage: _sendMessage,
                            disabled: true,
                          ),
                        ),
                      ],
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Column(
                        children: [
                          Expanded(child: FullScreenLoadingWidget()),
                          Container(
                            padding: EdgeInsets.only(left: 10, bottom: 2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            child: NewMessage(
                              onSendMessage: _sendMessage,
                              disabled: true,
                            ),
                          ),
                        ],
                      );
                    default:
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              child: ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    ChatMessage message = snapshot.data[index];
                                    return TextMessage(
                                      chatMessage: message,
                                      isSent:
                                          _currentUser.uid == message.fromId,
                                    );
                                  }),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, bottom: 2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey)),
                            child: NewMessage(
                              chatId: chatIdSnapshot.data,
                              onSendMessage: _sendMessage,
                              disabled: false,
                            ),
                          ),
                        ],
                      );
                  }
                });
          }),
    );
  }
}
