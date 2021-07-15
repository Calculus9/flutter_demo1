class Utils {
  // 获取系统当前的时间戳
  static currentTimeSeconds() {
    var now = new DateTime.now();
    return (now.microsecondsSinceEpoch);
  }

  // 将时间戳转换成时间字符串
  static String getDateTime(seconds) {
    var date = DateTime.fromMicrosecondsSinceEpoch(seconds);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  // 将文件字节转为B, KB, MB, GB
  static getFileSize(fileSize) {
    var res = "";
    if (fileSize < 1024) {
      res = "${fileSize}B";
    } else if (fileSize < (1024 * 1024)) {
      var temp = fileSize / 1024;
      temp = temp.toStringAsFixed(2);
      res = temp + 'KB';
    } else if (fileSize < (1024 * 1024 * 1024)) {
      var temp = fileSize / (1024 * 1024);
      temp = temp.toStringAsFixed(2);
      res = temp + 'MB';
    } else {
      var temp = fileSize / (1024 * 1024 * 1024);
      temp = temp.toStringAsFixed(2);
      res = temp + 'GB';
    }
    return res;
  }

  // 获取父文件名
  static String getCurPtahFileName(String path) {
    if ('/'.compareTo(path) == 0) return '根目录';
    int startIndex = path.lastIndexOf('/');
    if (startIndex == -1) return "";
    return path.substring(startIndex + 1);
  }

  //获取父文件目录
  static String getFatherDir(String path) {
    if ('/'.compareTo(path) == 0) return '/';
    int startIndex = path.lastIndexOf('/');
    if (startIndex <= 0) return '/';
    return path.substring(0, startIndex);
  }
}
