import 'package:chat_app/firebaseServices/authService.dart';
import 'package:chat_app/firebaseServices/userService.dart';
import 'package:chat_app/models/appUser.dart';
import 'package:chat_app/widgets/fullScreenEmpty.dart';
import 'package:chat_app/widgets/fullScreenError.dart';
import 'package:chat_app/widgets/fullScreenLoading.dart';
import 'file:///C:/Users/Shakthi/AndroidStudioProjects/chat_app/lib/screens/chat/userListItemWidget.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  static const routeName = '/user-list';

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  auth.User _currentUser;
  Stream<List<AppUser>> _users;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService.getInstance().getCurrentUser();
    _users = UserService.getInstance().getUsersStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start new chat')),
      body: StreamBuilder<List<AppUser>>(
        stream: _users,
        builder: (context, snapshot) {
          if (snapshot.hasError) return FullScreenErrorWidget();
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return FullScreenLoadingWidget();
            default:
              if (snapshot.data.isEmpty) return FullScreenEmptyWidget();
              return ListView(
                children: snapshot.data.map((user) {
                  if (user.id == _currentUser.uid) return Container();
                  return UserListItem(appUser: user);
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
