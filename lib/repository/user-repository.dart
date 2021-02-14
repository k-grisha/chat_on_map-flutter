import 'package:chat_on_map/model/chat-item.dart';
import 'package:chat_on_map/model/chat-user.dart';
import 'package:sqflite/sqflite.dart';

import 'db-helper.dart';
import 'message-repository.dart';

class UserRepository {
  static const String _TABLE_USER = "user";
  static const String _COLUMN_UUID = "uuid";
  static const String _COLUMN_NAME = "name";
  Future<Database> database;

  UserRepository() {
    database = DbHelper.initDbConnection();
  }

  Future<void> save(ChatUser user) async {
    final Database db = await database;
    await db.insert(
      _TABLE_USER,
      toMap(user),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<ChatUser> getUser(String uuid) async {
    final Database db = await database;
    List<Map> maps = await db.query(_TABLE_USER, where: _COLUMN_UUID + '=?', whereArgs: [uuid], limit: 1);
    return maps.isEmpty ? null : maps.map((m) => fromMap(m)).first;
  }

  Future<List<ChatItem>> getChatList(String uuid) async {
    final Database db = await database;
    List<Map> maps = await db.rawQuery("SELECT * FROM $_TABLE_USER AS u "
        "JOIN ${MessageRepository.TABLE_MESSAGES} AS m ON m.${MessageRepository.COLUMN_SENDER} = u.$_COLUMN_UUID OR m.${MessageRepository.COLUMN_RECIPIENT} = u.$_COLUMN_UUID  "
        "WHERE u.$_COLUMN_UUID != '$uuid' AND m.${MessageRepository.COLUMN_RECEIVED} =  "
        "(SELECT MAX(${MessageRepository.COLUMN_RECEIVED}) FROM ${MessageRepository.TABLE_MESSAGES} "
        "WHERE ${MessageRepository.COLUMN_RECIPIENT} = u.$_COLUMN_UUID OR ${MessageRepository.COLUMN_SENDER} = u.$_COLUMN_UUID  )  ");

    var res = maps.isEmpty ? [] : maps.map((m) => chatItemFromMap(m)).toList();
    return res;
  }

  ChatItem chatItemFromMap(Map<String, dynamic> map) {
    return ChatItem(map[_COLUMN_UUID], map[_COLUMN_NAME], map[MessageRepository.COLUMN_MESSAGE],
        DateTime.parse(map[MessageRepository.COLUMN_RECEIVED]));
  }

  ChatUser fromMap(Map<String, dynamic> map) {
    return ChatUser(map[_COLUMN_UUID], map[_COLUMN_NAME]);
  }

  Map<String, dynamic> toMap(ChatUser user) {
    return {
      _COLUMN_UUID: user.uuid,
      _COLUMN_NAME: user.name,
    };
  }
}
