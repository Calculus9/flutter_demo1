import 'package:flutter_demo1/bd_disk/bddisk_api_client.dart';
import 'package:flutter_demo1/file/disk_file.dart';
import 'package:flutter_demo1/file/file_store.dart';

class BdDiskFileStore implements FileStore {
  final apiClient = BdDiskApiClient();

  @override
  Future<List<DiskFile>> listFiles(String path,
          {String order = "name", int start = 0, int limit = 1000}) =>
      apiClient.getListFile(path, order: order, start: start, limit: limit);

  @override
  Future<List<DiskFile>> search(String key,
          {String path = '/',
          int recursion = 0,
          int page = 1,
          int num = 1000}) =>
      apiClient.getSearchFile(key);
}
