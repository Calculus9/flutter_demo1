import 'dart:io';

import 'package:flutter_demo1/file/disk_file.dart';

class SystemFile extends DiskFile {
  SystemFile.fromSystem(FileSystemEntity file) {
    FileStat fileStat = file.statSync();
    int timestamp = fileStat.modified.toLocal().millisecondsSinceEpoch ~/ 1000;
    int isDir = FileSystemEntity.isDirectorySync(file.path) == true ? 1 : 0;
    super.path = file.path;
    super.serverFilename = file.path.substring(file.parent.path.length + 1);
    super.serverCtime = timestamp;
    super.size = fileStat.size;
    super.isDir = isDir;
  }
}
