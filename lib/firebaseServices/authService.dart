import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  static AuthService _instance;

  static AuthService getInstance() {
    if (_instance == null) {
      print('AuthService --> instance init');
      _instance = AuthService();
    }
    return _instance;
  }

  String getErrorMessage(auth.FirebaseAuthException e) {
    print('AuthService -> error -> ${e.code}');
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already exists';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid credentials';
      default:
        return 'Something went wrong';
    }
  }

  auth.User getCurrentUser() {
    return auth.FirebaseAuth.instance.currentUser;
  }

  register(String email, String password, String displayName, String profilePicURL) async {
    auth.UserCredential userCredential = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user.updateProfile(displayName: displayName, photoURL: profilePicURL);
    return userCredential.user;
  }

  login(String email, String password) async {
    auth.UserCredential userCredential = await auth.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
}
