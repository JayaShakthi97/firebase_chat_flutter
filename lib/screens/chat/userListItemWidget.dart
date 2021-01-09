import 'package:chat_app/models/appUser.dart';
import 'package:chat_app/screens/chat/chatThreadScreen.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final AppUser appUser;

  const UserListItem({Key key, @required this.appUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appUser.displayName),
      subtitle: Text(appUser.email),
      onTap: () => Navigator.pushReplacementNamed(
          context, ChatThreadScreen.routeName,
          arguments: ChatThreadScreenPayload(appUser, null)),
    );
  }
}
