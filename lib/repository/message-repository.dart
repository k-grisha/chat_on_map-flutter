import 'package:chat_on_map/model/chat-message.dart';
import 'package:sqflite/sqflite.dart';

import 'db-helper.dart';

class MessageRepository {
  static const String TABLE_MESSAGES = "messages";
  static const String COLUMN_ID = "id";
  static const String COLUMN_SENDER = "sender";
  static const String COLUMN_RECIPIENT = "recipient";
  static const String COLUMN_MESSAGE = "message";
  static const String COLUMN_RECEIVED = "received";
  Future<Database> database;

  MessageRepository() {
    database = DbHelper.initDbConnection();
  }

  Future<void> save(TextMessage message) async {
    final Database db = await database;
    await db.insert(
      TABLE_MESSAGES,
      toMap(message),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<void> saveAll(List<TextMessage> messages) async {
    final Database db = await database;
    var batch = db.batch();
    messages.forEach((msg) {
      batch.insert(TABLE_MESSAGES, toMap(msg));
    });
    await batch.commit(noResult: true);
  }

  Future<int> getMaxMessageId(String uuid) async {
    final Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX(id) FROM " + TABLE_MESSAGES + " WHERE recipient='" + uuid + "'"));
  }

  Future<List<TextMessage>> getAll(String uuid1, String uuid2) async {
    final Database db = await database;
    List<Map> maps = await db.query(TABLE_MESSAGES,
        columns: [COLUMN_ID, COLUMN_SENDER, COLUMN_RECIPIENT, COLUMN_MESSAGE, COLUMN_RECEIVED],
        where: '(recipient = ? AND sender = ?) OR (recipient = ? AND sender = ?)',
        whereArgs: [uuid1, uuid2, uuid2, uuid1],
        orderBy: COLUMN_ID + ' DESC');
    var res = maps.isEmpty ? [] : maps.map((m) => fromMap(m)).toList();
    return res;
  }

  TextMessage fromMap(Map<String, dynamic> map) {
    return TextMessage(map[COLUMN_ID], map[COLUMN_SENDER], map[COLUMN_RECIPIENT], map[COLUMN_MESSAGE],
        DateTime.parse(map[COLUMN_RECEIVED]));
  }

  Map<String, dynamic> toMap(TextMessage chatMessage) {
    return {
      COLUMN_ID: chatMessage.id,
      COLUMN_SENDER: chatMessage.sender,
      COLUMN_RECIPIENT: chatMessage.recipient,
      COLUMN_MESSAGE: chatMessage.message,
      COLUMN_RECEIVED: chatMessage.received.toIso8601String(),
    };
  }
}
