import 'dart:io';

import 'package:flutter_demo1/file/disk_file.dart';
import 'package:flutter_demo1/file/file_store.dart';
import 'package:flutter_demo1/system_file.dart';

class SystemFileStore implements FileStore {
  @override
  Future<List<DiskFile>> listFiles(String path,
      {String order = 'name', int start = 0, int limit = 1000}) async {
    List<DiskFile> diskFiles = [];

    var dir = Directory(path);
    var listOfFiles = await dir.list().toList();
    listOfFiles.forEach((file) {
      diskFiles.add(SystemFile.fromSystem(file));
    });
    return diskFiles;
  }
}
