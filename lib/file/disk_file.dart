class DiskFile {
  ///文件路径
  String path;

  ///文件名称
  String serverFilename;

  ///是否目录，0文件，1目录
  int isDir;

  /// 文件在服务器修改时间
  int serverCtime = 0;

  /// 文件大小B
  int size = 0;

  ///文件类型,1视频、2音频、3图片、4文档、5应用、6其他、7种子
  int category = 0;

  DiskFile(
      {this.path,
      this.serverFilename,
      this.serverCtime,
      this.size = 0,
      this.isDir = 1,
      this.category = 6});
}
