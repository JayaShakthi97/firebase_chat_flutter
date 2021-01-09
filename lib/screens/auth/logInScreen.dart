import 'file:///C:/Users/Shakthi/AndroidStudioProjects/chat_app/lib/screens/auth/registerScreen.dart';
import 'package:chat_app/firebaseServices/authService.dart';
import 'package:chat_app/screens/chat/chatListScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LogInScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _success;
  bool _loading = false;
  String _userEmail;

  void _performLogIn() async {
    setState(() {
      _loading = true;
    });
    try {
      await AuthService.getInstance()
          .login(_emailController.text, _passwordController.text);
      Navigator.pushReplacementNamed(context, ChatListScreen.routeName);
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        _success = false;
        _loading = false;
      });
      final snackBar =
      SnackBar(content: Text(AuthService.getInstance().getErrorMessage(e)));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('LogIn'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                child:_loading ? CircularProgressIndicator() : RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _performLogIn();
                    }
                  },
                  child: const Text('LogIn'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(_success == null
                    ? ''
                    : (_success
                    ? 'Successfully Login ' + _userEmail
                    : 'Login failed')),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                  },
                  child: const Text('Go to registration'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
