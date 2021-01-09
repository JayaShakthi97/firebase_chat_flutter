import 'package:chat_app/models/appUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  // db user collection
  final _dbUserCollection = 'users';

  static UserService _instance;
  CollectionReference users;

  UserService._() {
    this.users = FirebaseFirestore.instance.collection(_dbUserCollection);
  }

  static UserService getInstance() {
    if (_instance == null) {
      print('UserService --> instance init');
      _instance = UserService._();
    }
    return _instance;
  }

  addUser(AppUser user) async {
    return await users.doc(user.id).set(user.toMap());
  }

  Stream<List<AppUser>> getUsersStream() {
    return users.snapshots().map((snapshot) => snapshot.docs
        .map((document) => AppUser.fromMap(document.data()))
        .toList());
  }

  Future<AppUser> getAppUser(String id) async {
    DocumentSnapshot userDoc = await users.doc(id).get();
    return AppUser.fromMap(userDoc.data());
  }
}
