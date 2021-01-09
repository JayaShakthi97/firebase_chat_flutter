import 'package:chat_app/util/enumUtil.dart';

enum MessageContentType { text, image, sticker }

class ChatMessage {
  // db names
  final _dbMessage = 'message';
  final _dbContentType = 'content_type';
  final _dbFromId = 'from_id';
  final _dbToId = 'to_id';
  final _dbSentAt = 'sent_at';
  static const dbCreatedAt = 'created_at';

  // attributes
  String message;
  MessageContentType contentType;
  String fromId;
  String toId;
  DateTime sentAt;
  dynamic createdAt;

  ChatMessage(
      {this.message,
      this.contentType,
      this.fromId,
      this.toId,
      this.sentAt,
      this.createdAt});

  ChatMessage.fromMap(Map<String, dynamic> data) {
    this.message = data[_dbMessage];
    this.contentType = EnumUtil().enumFromString(
        data[_dbContentType].toString(), MessageContentType.values);
    this.fromId = data[_dbFromId];
    this.toId = data[_dbToId];
    this.sentAt = data[_dbSentAt]?.toDate();
    this.createdAt = data[dbCreatedAt]?.toDate();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data[_dbMessage] = this.message;
    data[_dbContentType] = EnumUtil().enumToString(this.contentType);
    data[_dbFromId] = this.fromId;
    data[_dbToId] = this.toId;
    data[_dbSentAt] = this.sentAt;
    data[dbCreatedAt] = this.createdAt;
    return data;
  }
}
