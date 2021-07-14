class Utils {
  static int currentTimeSeconds() =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;
  static int currentTimeSecond() =>
      DateTime.now().microsecondsSinceEpoch ~/ 1000;

  static String getCurPtahFileName(String path) {
    if('/'.compareTo(path) == 0)
    return '根目录';
    int startIndex = path.lastIndexOf('/');
    if(startIndex == -1) return "";
    return path.substring(startIndex+1);
  }

  static String getFatherDir(String path) {
    if('/'.compareTo(path) == 0)
    return '/';
    int startIndex = path.lastIndexOf('/');
    if(startIndex <= 0) return '/';
    return path.substring(0,startIndex);
  }
}
