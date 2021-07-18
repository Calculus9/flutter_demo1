import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/bd_disk/bd_disk_file_store.dart';
import 'package:flutter_demo1/file/file_store.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
import 'package:flutter_demo1/search/search_page.dart';
import 'package:flutter_demo1/system/system_file_store.dart';
import 'package:flutter_demo1/utils.dart';
import 'package:path/path.dart' as PathUtils;
import 'disk_file.dart';
import 'file_list_widget.dart';

class FilePage extends StatefulWidget {
  FileStore _fileStore = BdDiskFileStore();
  String rootpath;
  bool allowPop;

  FilePage(
      {FileStore fileStore,
      this.rootpath = '/storage/emulated/0',
      this.allowPop = false}) {
    if (fileStore != null) _fileStore = fileStore;
  }
  @override
  _FilePageState createState() => _FilePageState();
}

enum FilesState { loading, loaded, fail }

class _FilePageState extends State<FilePage> {
  /// 文件列表
  List<DiskFile> listOfDiskFiles = [];

  /// 空文件夹
  final List<DiskFile> _emptyDir = [];

  String _title = '根目录';
  String _currPath = '/';
  String _failMsg = "";

  FilesState _filesState = FilesState.loaded;

  @override
  Future<void> initState() {
    _currPath = widget.rootpath;
    _refreshDiskFiles();

    super.initState();
  }

  /// 搜索框被点击
  _onFocusSearchInputWidget() {
    // Navigator.of(context).pop();
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (context) => new SearchPage(
                widget._fileStore,
                currPath: _currPath,
              )),
    );
  }

  Widget _cancel() {
    // ignore: deprecated_member_use
    return FlatButton(
      color: Colors.blue,
      child: Text(
        "取消",
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  /// 刷新磁盘文件
  void _refreshDiskFiles() {
    setState(() => _filesState = FilesState.loading);
    if (_currPath == '/storage/emulated/0') _currPath = '/';
    widget._fileStore.listFiles(_currPath).then((files) {
      setState(() {
        listOfDiskFiles = files;
        _title = PathUtils.basenameWithoutExtension(_currPath);
        _filesState = FilesState.loaded;
      });
    }, onError: (e) {
      setState(() {
        _filesState = FilesState.fail;
        if (e is FileSystemException) {
        } else {
          _failMsg = e.toString();
        }
      });
    });
  }

  /// 返回上一级菜单
  _onBackParentDir() {
    if (widget.rootpath.compareTo(_currPath) == 0 && widget.allowPop) {
      Navigator.pop(context);
      return Future.value(false);
    }

    _currPath = Utils.getFatherDir(_currPath);
    _title = Utils.getCurPtahFileName(_currPath);
    _refreshDiskFiles();
  }

  /// 进入下一级菜单
  _onDiskFileTap(DiskFile file) {
    if (file.isDir == 0) return;
    _title = file.serverFilename;
    _currPath = file.path;
    print(_currPath);
    _refreshDiskFiles();
  }

  @override
  Widget build(BuildContext context) => _buildFilesWidget();

  Widget _buildFilesWidget() {
    switch (_filesState) {
      case FilesState.loading:
        return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 40,
            ));
      case FilesState.loaded:
        return loaded_build();
      case FilesState.fail:
        return Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                ),
                IconButton(
                    icon: Icon(Icons.refresh),
                    iconSize: 96,
                    onPressed: _refreshDiskFiles),
                Text(_failMsg)
              ],
            ));
    }
  }

  // 构建文件页面
  Widget loaded_build() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title == "" ? "根目录" : _title,
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

// @override
  // Widget build(BuildContext context) {
  //
  // }
}
