import 'package:chat_app/screens/auth/logInScreen.dart';
import 'package:chat_app/screens/auth/registerScreen.dart';
import 'package:chat_app/screens/chat/chatListScreen.dart';
import 'package:chat_app/screens/chat/chatThreadScreen.dart';
import 'package:chat_app/screens/chat/userListScreen.dart';
import 'package:chat_app/screens/splashScreen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case ChatListScreen.routeName:
        return MaterialPageRoute(builder: (context) => ChatListScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case LogInScreen.routeName:
        return MaterialPageRoute(builder: (context) => LogInScreen());
      case UserListScreen.routeName:
        return MaterialPageRoute(builder: (context) => UserListScreen());
      case ChatThreadScreen.routeName:
        final ChatThreadScreenPayload args = routeSettings.arguments;
        return MaterialPageRoute(
            builder: (context) =>
                ChatThreadScreen(appUser: args.appUser, chatId: args.chatId));
    }
  }
}
