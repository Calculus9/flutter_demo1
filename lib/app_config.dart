import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  factory AppConfig() => _getInstance();

  static AppConfig get instance => _getInstance();
  static AppConfig _instance;

  AppConfig._internal() {}

  static AppConfig _getInstance() {
    if (_instance == null) {
      _instance = new AppConfig._internal();
    }
    return _instance;
  }

  String defaultFilesRootPath = '/';
  bool showAllFiles = false;
}
