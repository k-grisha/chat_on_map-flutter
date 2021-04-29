import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> initDbConnection() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'chat_database.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE user (uuid CHARACTER(36) PRIMARY KEY, name CHARACTER(50), avatar CHARACTER(200))');
        db.execute(
            'CREATE TABLE messages (id INTEGER PRIMARY KEY, sender CHARACTER(36), recipient CHARACTER(36), message TEXT, received TEXT)');
      },
      version: 1,
    );
  }
}
