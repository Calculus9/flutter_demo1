import 'package:flutter_demo1/bd_disk/bddisk_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final apiClient = BdDiskApiClient();

  test("test BdDiskApiClient getUserInfo", () async {
    var userInfo = await apiClient.getUserInfo();
    expect(userInfo != null, true);
    expect(userInfo.errno, 0);
    expect(userInfo.vipType, 0);
  });

  test("test BdDiskApiClient getDiskQuota", () async {
    var userInfo = await apiClient.getDiskQuota();
    expect(userInfo != null, true);
    expect(userInfo.errno, 0);
  });

  test("test BdDiskApiClient getListFile", () async {
    var files = await apiClient.getListFile('/');
    expect(files != null, true);
    expect(files.isNotEmpty, true);
  });
}
