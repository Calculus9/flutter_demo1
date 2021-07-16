import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/file/file_store.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
import 'package:flutter_demo1/search/search_page.dart';
import 'package:flutter_demo1/system_file_store.dart';
import 'package:flutter_demo1/utils.dart';

import 'disk_file.dart';
import 'file_list_widget.dart';

class FilePage extends StatefulWidget {
  FileStore _fileStore = SystemFileStore();

  FilePage({FileStore fileStore}) {
    if (fileStore != null) _fileStore = fileStore;
  }
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  /// 文件列表
  List<DiskFile> listOfDiskFiles = [];

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

  /// 刷新磁盘文件
  _refreshDiskFiles() {
    widget._fileStore.listFiles(_currPath).then((files) {
      setState(() {
        listOfDiskFiles = files;
      });
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
    _currPath = '/storage/emulated/0';
    _refreshDiskFiles();

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
