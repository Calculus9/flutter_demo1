import 'package:flutter/material.dart';
import 'package:flutter_demo1/file/disk_file.dart';
import 'package:flutter_demo1/utils.dart';

// ignore: must_be_immutable
typedef OnDiskFileTapCallback = void Function(DiskFile file);

// ignore: must_be_immutable
class FileListWidget extends StatelessWidget {
  List<DiskFile> _listOfDiskFiles;
  OnDiskFileTapCallback _diskFileTapCallback;

  FileListWidget(this._listOfDiskFiles, this._diskFileTapCallback);

  // 渲染文件夹
  Widget _buildFolderItem(BuildContext context, DiskFile file) {
    return InkWell(
      child: Container(
        child: ListTile(
          leading: Image.asset("assets/folder.png"),
          title: Row(
            children: [Expanded(child: Text(file.serverFilename))],
          ),
          subtitle: Text("${Utils.getDateTime(file.serverCtime)}"),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () => _diskFileTapCallback(file),
    );
  }

  // 渲染文件item
  Widget _buildFileItem(BuildContext context, DiskFile file) {
    // 水波纹
    return InkWell(
      child: Container(
        child: ListTile(
          leading: Image.asset("assets/file.png"),
          title: Row(
            children: [Expanded(child: Text(file.serverFilename))],
          ),
          subtitle: Text("${Utils.getDateTime(file.serverCtime)}"+" "+"${Utils.getFileSize(file.size)}")
        ),
      ),
      onTap: () => _diskFileTapCallback(file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._listOfDiskFiles.isEmpty
        ? Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Icon(Icons.drive_file_move),
              Text("当前目录下没有文件")
            ],
          )
        : ListView.builder(
            /// 滚动列表
            itemCount: this._listOfDiskFiles.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var diskFile = _listOfDiskFiles[index];
              if (diskFile.isDir == 1)
                return _buildFolderItem(context, diskFile);
              else
                return _buildFileItem(context, diskFile);
            },
          );
  }
}
