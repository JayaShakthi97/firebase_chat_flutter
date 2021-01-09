import 'dart:convert';

import 'package:chat_app/models/chatMessage.dart';
import 'package:chat_app/models/chatRoom.dart';
import 'package:chat_app/util/enumUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class ChatService {
  // db chatRooms collection
  final _dbChatRoomsCollection = 'chatRooms';
  final _dbMessagesCollection = 'messages';

  static ChatService _instance;
  CollectionReference chatRooms;

  ChatService._() {
    this.chatRooms =
        FirebaseFirestore.instance.collection(_dbChatRoomsCollection);
  }

  static ChatService getInstance() {
    if (_instance == null) {
      print('ChatService --> instance init');
      _instance = ChatService._();
    }
    return _instance;
  }

  String _getHashedUserIds(String id1, String id2) {
    String input = '';
    int compared = id1.compareTo(id2);
    if (compared < 0)
      input = id1 + id2;
    else
      input = id2 + id1;
    // hashing
    var bytes = utf8.encode(input);
    var digest = sha1.convert(bytes);
    return digest.toString();
  }

  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return chatRooms.snapshots().map(
        (event) => event.docs.map((e) => ChatRoom.fromMap(e.data())).toList());
  }

  Future<String> initializeChatRoom(String user1, String user2) async {
    String chatDocumentId = _getHashedUserIds(user1, user2);
    DocumentSnapshot chatDocument = await chatRooms.doc(chatDocumentId).get();
    if (chatDocument.exists) return chatDocument.id;
    await chatRooms.doc(chatDocumentId).set({
      ChatRoom.dbId: chatDocumentId,
      ChatRoom.dbMembers: [user1, user2],
      ChatRoom.dbType: EnumUtil().enumToString(ChatRoomType.private)
    });
    return chatDocumentId;
  }

  Future<DocumentSnapshot> getChatRoom(String user1, String user2) {
    return chatRooms.doc(_getHashedUserIds(user1, user2)).get();
  }

  Stream<List<ChatMessage>> getChatMessages(String chatId) {
    return chatRooms
        .doc(chatId)
        .collection(_dbMessagesCollection)
        .orderBy(ChatMessage.dbCreatedAt, descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => ChatMessage.fromMap(e.data())).toList());
  }

  createMessage(String chatId, ChatMessage chatMessage) async {
    return await Future.wait([
      chatRooms
          .doc(chatId)
          .collection(_dbMessagesCollection)
          .add(chatMessage.toMap()),
      chatRooms
          .doc(chatId)
          .update({ChatRoom.dbLastMessage: chatMessage.toMap()})
    ]);
  }
}
