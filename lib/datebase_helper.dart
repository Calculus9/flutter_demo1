import 'dart:async';

import 'package:flutter_demo1/search/search_history.dart';
import 'package:flutter_demo1/user.dart';
import 'package:path/path.dart' as PathUtils;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._privateConstructor();

  static final DbHelper _instance = DbHelper._privateConstructor();

  static DbHelper get instance => _instance;

  factory DbHelper() {
    return _instance;
  }

  Database _db;
  Future<Database> get db async {
    if (_db == null) _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
// 获取数据库文件的存储路径
    var dbPath = await getDatabasesPath();
    var path = PathUtils.join(dbPath, User.dbName);
    return await openDatabase(path, version: User.dbVersion);
  }

//根据数据库文件路径和数据库版本号创建数据库表
  Future<void> _onCreate(Database db, int version) {
    User.sqlCreateTables.forEach((sql) {
      db.execute(sql);
    });
  }

  Future<void> close() {
    if (_db != null) return _db.close();
    return null;
  }

  //增加
  Future<SearchHistory> insert(SearchHistory searchHistory) async {
    var database = await db;

    try {
      searchHistory.id =
          await database.insert(User.searchHistoryTable, searchHistory.toMap());
    } catch (e) {
      print(e);
    }
    return searchHistory;
  }

  //查询所有
  Future<List<SearchHistory>> queryAll() async {
    var database = await db;
    var listOfObjs = await database.query(User.searchHistoryTable);
    return listOfObjs.map((map) => SearchHistory.fromMap(map));
  }

  //查询某个
  Future<List<SearchHistory>> search(String keyword) async {
    var database = await db;
    var listOfObjets = await database.query(User.searchHistoryTable,
        where: 'keyword like %?%', whereArgs: [keyword]);
    return listOfObjets.map((map) => SearchHistory.fromMap(map));
  }

//  删除
  Future<bool> delete(int id) async {
    var database = await db;
    var count = await database.delete(User.searchHistoryTable, where: 'id = ?', whereArgs: [id]);
    return count == 1;
  }
  //删除所有
  Future<int> deleteAll() async {
    var database = await db;
    return await database.delete(User.searchHistoryTable);
  }
}
