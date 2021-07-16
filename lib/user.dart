class User {
  User._();
  static const String accountKey = "account_key";
  static const String passwordKey = "password_Key";
  static const String dbName = "bddisk";
  static const int dbVersion =1;
  static const searchHistoryTable ="search_history";
  static const sqlCreateTables = [
    ' create table "$searchHistoryTable"("id" integer primary key autoincrement , '
        '"keyword" text unique,"time" integer) ',
  ];
}
