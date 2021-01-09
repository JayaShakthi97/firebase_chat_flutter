import 'package:chat_app/firebaseServices/authService.dart';
import 'package:chat_app/firebaseServices/chatService.dart';
import 'package:chat_app/models/chatRoom.dart';
import 'package:chat_app/screens/chat/chatRoomsListItemWidget.dart';
import 'package:chat_app/screens/chat/userListScreen.dart';
import 'package:chat_app/widgets/fullScreenError.dart';
import 'package:chat_app/widgets/fullScreenLoading.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chat-list';

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream<List<ChatRoom>> _chatRoomsStream;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = AuthService.getInstance().getCurrentUser().uid;
    _chatRoomsStream = ChatService.getInstance().getChatRooms(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat List')),
      body: StreamBuilder<List<ChatRoom>>(
          stream: _chatRoomsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return FullScreenErrorWidget();
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return FullScreenLoadingWidget();
              default:
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      ChatRoom chatRoom = snapshot.data[index];
                      return ChatRoomListItem(
                          chatRoom: chatRoom, currentUserId: currentUserId);
                    });
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, UserListScreen.routeName),
      ),
    );
  }
}
