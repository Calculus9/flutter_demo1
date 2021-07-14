import 'package:flutter/material.dart';
import 'package:flutter_demo1/disk_file.dart';

// ignore: must_be_immutable
typedef OnDiskFileTapCallback = void Function(DiskFile file);

class FileListWidget extends StatelessWidget {
  List<DiskFile> _listOfDiskFiles;
  OnDiskFileTapCallback _diskFileTapCallback;
  FileListWidget(this._listOfDiskFiles, _diskFileTapCallback);

  Widget _buildFolderItem(BuildContext context, DiskFile file) {
    return InkWell(
      child: Container(
        child: ListTile(
          leading: Image.asset("assets/folder.png"),
          title: Row(
            children: [Expanded(child: Text(file.serverFilename))],
          ),
          subtitle: Text(file.serverCtime.toString()),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () => _diskFileTapCallback(file),
    );
  }

  Widget _buildFileItem(BuildContext context, DiskFile file) {
    return InkWell(
      child: Container(
        child: ListTile(
          leading: Image.asset("assets/file.png"),
          title: Row(
            children: [Expanded(child: Text(file.serverFilename))],
          ),
          subtitle: Text(file.serverCtime.toString()),
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
