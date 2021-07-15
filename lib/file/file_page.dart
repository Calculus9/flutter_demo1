import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
import 'package:flutter_demo1/search/search_page.dart';
import 'package:flutter_demo1/utils.dart';

import 'disk_file.dart';
import 'file_list_widget.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
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

  /// 搜索框被点击
  _onFocusSearchInputWidget() {
    // Navigator.of(context).pop();
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => new SearchPage()),
    );
  }

  /// 提交搜索框内容
  _onSubmittedSearchInputWidget(String keyword) {}

  /// 更新磁盘文件
  _refreshDiskFiles() {
    setState(() {
      int index = _currPath.lastIndexOf('/');

      if (_currPath.length == 1) listOfDiskFiles = _rootPathFilesDir;
      if (_currPath.length > 1) listOfDiskFiles = _subPathFilesDir;
      if (index > 0) listOfDiskFiles = _emptyDir;
    });
  }

  /// 返回上一级菜单
  _onBackParentDir() {
    _currPath = Utils.getFatherDir(_currPath);
    _title = Utils.getCurPtahFileName(_currPath);
    _refreshDiskFiles();
  }

  /// 进入下一级菜单
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
        title: Text(
          _title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xffeeeeee),
        elevation: 0,
        leading: _currPath.length == 1
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                onPressed: _onBackParentDir),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: 45,
              child: SearchInputWidget(onTap: _onFocusSearchInputWidget),
            ),
            Center(child: FileListWidget(listOfDiskFiles, _onDiskFileTap))
          ],
        ),
      ),
    );
  }
}
