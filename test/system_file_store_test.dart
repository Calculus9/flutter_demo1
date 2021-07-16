import 'package:flutter_demo1/system/system_file_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fileStore = SystemFileStore();
  test('SystemFileStore ListFiles Funntion', () async {
    var listtOfList = await fileStore.listFiles('D:/Study');
    listtOfList.forEach(print);
  });
}
