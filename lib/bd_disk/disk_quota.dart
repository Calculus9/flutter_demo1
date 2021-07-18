class DiskQuota {
  int errno;
  int used;
  int total;
  int requestId;

  DiskQuota({
      this.errno, 
      this.used, 
      this.total, 
      this.requestId});

  DiskQuota.fromJson(dynamic json) {
    errno = json["errno"];
    used = json["used"];
    total = json["total"];
    requestId = json["request_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = errno;
    map["used"] = used;
    map["total"] = total;
    map["request_id"] = requestId;
    return map;
  }

}