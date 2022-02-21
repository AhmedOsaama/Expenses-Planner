import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class DBhelper{
  static Future<sql.Database> database() async{
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(join(dbPath,'transactions.db'), onCreate: (db,version){
      return db.execute("CREATE TABLE transactions(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT)");
    },version: 1);
  }

  static Future<void> insert(String table,Map<String, dynamic> data) async{
    final db = await DBhelper.database();
    db.insert(table, data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic>>> getData(String table) async{
    final db = await DBhelper.database();
    return db.query(table);
  }

  static Future<void> update(String table, String id, Map<String, dynamic> data) async {
    final db = await DBhelper.database();
    db.update(table, data, where: 'id = ?', whereArgs: [id],conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBhelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}