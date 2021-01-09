import 'package:chat_app/firebaseServices/authService.dart';
import 'package:chat_app/firebaseServices/userService.dart';
import 'package:chat_app/models/appUser.dart';
import 'package:chat_app/screens/chat/chatListScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'logInScreen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _success;
  bool _loading = false;
  String _userEmail;

  void _performRegister() async {
    setState(() {
      _loading = true;
    });
    auth.User user;
    try {
      user = await AuthService.getInstance().register(_emailController.text,
          _passwordController.text, _displayNameController.text, null);
      print(user.uid);
      AppUser appUser = AppUser(
          id: user.uid,
          email: user.email,
          displayName: _displayNameController.text);
      await UserService.getInstance().addUser(appUser);
      Navigator.pushReplacementNamed(context, ChatListScreen.routeName);
    } on auth.FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        _success = false;
        _loading = false;
      });
      final snackBar =
          SnackBar(content: Text(AuthService.getInstance().getErrorMessage(e)));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } on Exception catch (e) {
      print(e);
      setState(() {
        _success = false;
      });
      final snackBar = SnackBar(content: Text('Something went wrong'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(labelText: 'Display name'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: _loading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _performRegister();
                            }
                          },
                          child: const Text('Register'),
                        ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_success == null
                      ? ''
                      : (_success
                          ? 'Successfully registered ' + _userEmail
                          : 'Registration failed')),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LogInScreen.routeName);
                    },
                    child: const Text('Go to login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
