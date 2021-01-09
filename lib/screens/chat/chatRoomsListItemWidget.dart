import 'package:chat_app/firebaseServices/userService.dart';
import 'package:chat_app/models/appUser.dart';
import 'package:chat_app/models/chatRoom.dart';
import 'package:chat_app/screens/chat/chatThreadScreen.dart';
import 'package:flutter/material.dart';

class ChatRoomListItem extends StatefulWidget {
  final ChatRoom chatRoom;
  final String currentUserId;

  const ChatRoomListItem(
      {Key key, @required this.chatRoom, @required this.currentUserId})
      : super(key: key);

  @override
  _ChatRoomListItemState createState() => _ChatRoomListItemState();
}

class _ChatRoomListItemState extends State<ChatRoomListItem> {
  Future<AppUser> _user;

  @override
  void initState() {
    super.initState();
    String otherUserId = widget.chatRoom.members
        .singleWhere((element) => element != widget.currentUserId);
    _user = UserService.getInstance().getAppUser(otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(
              title: Text('Error'),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                padding: EdgeInsets.all(10),
                child: LinearProgressIndicator(),
              );
            default:
              return ListTile(
                title: Text(snapshot.data.displayName),
                subtitle: Text(widget.chatRoom.lastMessage.message),
                onTap: () => Navigator.pushNamed(
                    context, ChatThreadScreen.routeName,
                    arguments: ChatThreadScreenPayload(snapshot.data, widget.chatRoom.id)),
              );
          }
        });
  }
}
