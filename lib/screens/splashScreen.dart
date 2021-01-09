import 'package:chat_app/firebaseServices/authService.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'auth/logInScreen.dart';
import 'chat/chatListScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      auth.User user = AuthService.getInstance().getCurrentUser();
      if(user == null) {
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      } else {
          user.reload().then((value) {
            Navigator.pushReplacementNamed(context, ChatListScreen.routeName);
          }).catchError((_) {
            Navigator.pushReplacementNamed(context, LogInScreen.routeName);
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('loading...'),
      ),
    );
  }
}
