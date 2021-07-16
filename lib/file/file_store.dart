import 'package:flutter_demo1/file/disk_file.dart';

abstract class FileStore {
//  获取文件列表
  Future<List<DiskFile>> listFiles(String path,
      {String order = "name", int start = 0, int limit = 1000});
}
