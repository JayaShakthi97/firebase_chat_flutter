import 'package:chat_app/models/chatMessage.dart';
import 'package:chat_app/util/enumUtil.dart';

enum ChatRoomType { private, group }

class ChatRoom {
  static const dbId = 'id';
  static const dbMembers = 'members';
  static const dbLastMessage = 'last_message';
  static const dbType = 'type';

  String id;
  ChatRoomType type;
  List<String> members;
  ChatMessage lastMessage;

  ChatRoom.fromMap(Map<String, dynamic> data) {
    this.id = data[dbId];
    this.type = EnumUtil()
        .enumFromString(data[dbType].toString(), ChatRoomType.values);
    this.members = List<String>.from(data[dbMembers]);
    this.lastMessage = ChatMessage.fromMap(data[dbLastMessage]);
  }
}
