import 'package:flutter/material.dart';
import 'package:flutter_demo1/disk_file.dart';
import 'package:flutter_demo1/file_list_widget.dart';
import 'package:flutter_demo1/search_input_widget.dart';
import 'package:flutter_demo1/utils.dart';

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 文件列表
  List<DiskFile> listOfDiskFiles = [];

  /// 根目录
  final _rootPathFilesDir = [
    DiskFile(
      path: '/实验室一',
      serverFilename: '实验一',
      serverCtime: Utils.currentTimeSeconds(),
    ),
    DiskFile(
      path: '/实验室二',
      serverFilename: '实验二',
      serverCtime: Utils.currentTimeSeconds(),
    ),
    DiskFile(
      path: '/实验室三',
      serverFilename: '实验三',
      serverCtime: Utils.currentTimeSeconds(),
    ),
    DiskFile(
        path: '/第一讲.pptx',
        serverFilename: '第一讲.pptx',
        serverCtime: Utils.currentTimeSeconds(),
        isDir: 0,
        category: 4,
        size: 989),
    DiskFile(
        path: '/第二讲.pptx',
        serverFilename: '第二讲.pptx',
        serverCtime: Utils.currentTimeSeconds(),
        isDir: 0,
        category: 4,
        size: 9839),
  ];

  /// 子目录
  final _subPathFilesDir = [
    DiskFile(
      path: '/实验室一/源代码',
      serverFilename: '源代码',
      serverCtime: Utils.currentTimeSeconds(),
    ),
    DiskFile(
        path: '/实验室一/实验指导书. pdf',
        serverFilename: '实验指导书. pdf',
        serverCtime: Utils.currentTimeSeconds(),
        isDir: 0,
        category: 4,
        size: 983),
  ];

  /// 空文件夹
  final List<DiskFile> _emptyDir = [];

  String _title = '根目录';
  String _currPath = '/';

  var _selectedIndex = 0; // 当前page

  final List<BottomNavigationBarItem> bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.archive), label: "文件"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
  ]; //底部导航栏items

  _onFocusSearchInputWidget() {
    print("搜索框被点击");
  }

  _onSubmittedSearchInputWidget(String keyword) {
    print(keyword);
  }

  _refreshDiskFiles() {
    setState(() {
      int index = _currPath.lastIndexOf('/');

      if (_currPath.length == 1) listOfDiskFiles = _rootPathFilesDir;
      if (_currPath.length > 1) listOfDiskFiles = _subPathFilesDir;
      if (index > 0) listOfDiskFiles = _emptyDir;

      print(listOfDiskFiles);
    });
  }

  _onDiskFileTap(DiskFile file) {
    if (file.isDir == 0) return;
    _title = file.serverFilename;
    _currPath = file.path;
    _refreshDiskFiles();
  }

  @override
  void initState() {
    listOfDiskFiles = _rootPathFilesDir;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("根目录"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 45,
              child: SearchInputWidget(
                  _onSubmittedSearchInputWidget, _onFocusSearchInputWidget),
            ),
            Center(child: FileListWidget(listOfDiskFiles, _onDiskFileTap))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
