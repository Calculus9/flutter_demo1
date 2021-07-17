class User {
  User._();
  static const String accountKey = "account_key";
  static const String passwordKey = "password_Key";
  static const String dbName = "bddisk.db";
  static const int dbVersion = 1;
  static const searchHistoryTable = "search_history";
  //建表操作
  static const sqlCreateTables = [
    '''
        create table $searchHistoryTable (
        "id" integer primary key autoincrement,"keyword" text unique not null,
        "time" text not null)
      '''
  ];
}
