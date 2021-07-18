import 'package:flutter_demo1/file/disk_file.dart';

class BdDiskFile extends DiskFile {
  int tkbindId;
  int serverMtime;
  int category;
  String realCategory;
  int isdir;
  int unlist;
  int operId;
  int serverAtime;
  int serverCtime;
  int wpfile;
  String serverFilename;
  int localMtime;
  int size;
  int share;
  String path;
  int localCtime;
  int pl;
  int fsId;

  BdDiskFile(
      {this.tkbindId,
      this.serverMtime,
      this.category,
      this.realCategory,
      this.isdir,
      this.unlist,
      this.operId,
      this.serverAtime,
      this.serverCtime,
      this.wpfile,
      this.serverFilename,
      this.localMtime,
      this.size,
      this.share,
      this.path,
      this.localCtime,
      this.pl,
      this.fsId});

  BdDiskFile.fromJson(dynamic json) {
    tkbindId = json["tkbind_id"];
    serverMtime = json["server_mtime"];
    category = json["category"];
    realCategory = json["real_category"];
    isdir = json["isdir"];
    unlist = json["unlist"];
    operId = json["oper_id"];
    serverAtime = json["server_atime"];
    serverCtime = json["server_ctime"];
    wpfile = json["wpfile"];
    serverFilename = json["server_filename"];
    localMtime = json["local_mtime"];
    size = json["size"];
    share = json["share"];
    path = json["path"];
    localCtime = json["local_ctime"];
    pl = json["pl"];
    fsId = json["fs_id"];

    super.path = path;
    super.serverCtime = serverCtime;
    super.isDir = isdir;
    super.serverFilename = serverFilename;
    super.size = size;
    super.category = category;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["tkbind_id"] = tkbindId;
    map["server_mtime"] = serverMtime;
    map["category"] = category;
    map["real_category"] = realCategory;
    map["isdir"] = isdir;
    map["unlist"] = unlist;
    map["oper_id"] = operId;
    map["server_atime"] = serverAtime;
    map["server_ctime"] = serverCtime;
    map["wpfile"] = wpfile;
    map["server_filename"] = serverFilename;
    map["local_mtime"] = localMtime;
    map["size"] = size;
    map["share"] = share;
    map["path"] = path;
    map["local_ctime"] = localCtime;
    map["pl"] = pl;
    map["fs_id"] = fsId;
    return map;
  }
}
