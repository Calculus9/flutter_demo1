import 'dart:async';
import 'dart:io';

import 'package:flutter_demo1/file/disk_file.dart';
import 'package:flutter_demo1/file/file_store.dart';
import 'package:flutter_demo1/system/system_file.dart';
import 'package:path/path.dart' as PathUtils;

import '../app_config.dart';

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

  @override
  Future<List<DiskFile>> search(String key,
      {String path = '/',
      int recursion = 0,
      int page = 1,
      int num = 1000}) async {
    Directory directory = Directory(path);
    var diskFiles = List<DiskFile>();

    int count = 0;
    int start = (page - 1) * num;
    var listOfFiles = directory.list(recursive: recursion == 1 ? true : false);
    var _diskFilesComplete = Completer();

    listOfFiles.listen(
      ((file) {
        var fileName = PathUtils.basename(file.path);
        print(fileName);

        if (file.path == null ||
            (fileName.substring(0, 1) == '.' &&
                !AppConfig.instance.showAllFiles) ||
            !fileName.toLowerCase().contains(key.toLowerCase()) ||
            count++ < start) return;

        if (count > (start + num)) {
          _diskFilesComplete.isCompleted
              ? null
              : _diskFilesComplete.complete('');
          return;
        }

        diskFiles.add(SystemFile.fromSystem(file));
      }),
      onDone: () => _diskFilesComplete.isCompleted
          ? null
          : _diskFilesComplete.complete(''),
      onError: (e) => _diskFilesComplete.completeError(e),
    );

    await _diskFilesComplete.future;

    return diskFiles;
  }
}
