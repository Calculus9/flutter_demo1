class BdDiskUser {
  String avatarUrl;
  String baiduName;
  String errmsg;
  int errno;
  String netdiskName;
  String requestId;
  int uk;
  int vipType;

  BdDiskUser({
      this.avatarUrl, 
      this.baiduName, 
      this.errmsg, 
      this.errno, 
      this.netdiskName, 
      this.requestId, 
      this.uk, 
      this.vipType});

  BdDiskUser.fromJson(dynamic json) {
    avatarUrl = json["avatar_url"];
    baiduName = json["baidu_name"];
    errmsg = json["errmsg"];
    errno = json["errno"];
    netdiskName = json["netdisk_name"];
    requestId = json["request_id"];
    uk = json["uk"];
    vipType = json["vip_type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["avatar_url"] = avatarUrl;
    map["baidu_name"] = baiduName;
    map["errmsg"] = errmsg;
    map["errno"] = errno;
    map["netdisk_name"] = netdiskName;
    map["request_id"] = requestId;
    map["uk"] = uk;
    map["vip_type"] = vipType;
    return map;
  }

}