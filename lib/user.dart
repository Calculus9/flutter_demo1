class User {
  User._();
  static final String keyUserInfo = 'json_user_info';
  static final String keyDiskQuota = 'json_disk_quota';
  static final String keyBdOAuth2Token = 'json_baidu_oauth2_token';
  static var tokenValue = "";

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
