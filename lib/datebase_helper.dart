import 'dart:async';

import 'package:flutter_demo1/search/search_history.dart';
import 'package:flutter_demo1/user.dart';
import 'package:path/path.dart' as PathUtils;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return instance;
  }

  Database _db;

  Future<Database> get db async {
    // ignore: unnecessary_null_comparison
    if (_db == null) _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    var dbPath = await getDatabasesPath();
    var path = PathUtils.join(dbPath, User.dbName);
    return await openDatabase(path,
        version: User.dbVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) {
    User.sqlCreateTables.forEach((sql) => db.execute(sql));
  }

  Future<void> close() {
    if (_db != null) {
      return _db.close();
    }
    return null;
  }

  //插入
  Future<SearchHistory> insert(SearchHistory searchHistory) async {
    var database = await db;

    try {
      searchHistory.id =
          await database.insert(User.searchHistoryTable, searchHistory.toMap());
      print("id: ${searchHistory.id}");
    } catch (e) {
      print(e);
    }
    return searchHistory;
  }

  //查询所有
  Future<List<SearchHistory>> queryAll() async {
    var database = await db;
    var listOfObjiects = await database.query(User.searchHistoryTable);
    var list = <SearchHistory>[];
    listOfObjiects.forEach((element) {
      list.add(SearchHistory.fromMap(element));
    });
    return list;
  }

  //搜索
  Future<List<SearchHistory>> search(String keyword) async {
    var database = await db;
    var listOfObjets = await database.query(User.searchHistoryTable,
        where: 'keyword like %?%', whereArgs: [keyword]);
    var list = <SearchHistory>[];
    listOfObjets.forEach((element) {
      list.add(SearchHistory.fromMap(element));
    });
    return list;
  }

  //删除
  Future<bool> delete(int id) async {
    var database = await db;
    var count = await database
        .delete(User.searchHistoryTable, where: 'id = ?', whereArgs: [id]);
    return count == 1;
  }

  //清空
  Future<int> deleteAll() async {
    var database = await db;
    return await database.delete(User.searchHistoryTable);
  }
}
