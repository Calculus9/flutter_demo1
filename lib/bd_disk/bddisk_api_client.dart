import 'dart:convert';
import 'dart:io';

import 'package:flutter_demo1/bd_disk/bd_disk_file.dart';
import 'package:flutter_demo1/bd_disk/bd_disk_user.dart';
import 'package:flutter_demo1/bd_disk/disk_quota.dart';
import 'package:flutter_demo1/user.dart';

class BdDiskApiClient {
//  由于使用http协议因此引入http进入
  final HttpClient httpClient;

//  构造函数
  BdDiskApiClient({HttpClient httpClient})
      :
        //外界传入一个httpClient，如果没有则默认
        this.httpClient = httpClient ?? HttpClient();

//  封装API
  final protocol = "https"; //协议
  final host = "pan.baidu.com";
  final userInfoPath = "/rest/2.0/xpan/nas";
  final diskQuotaPath = "/api/quota";
  final diskFilesPath = "/rest/2.0/xpan/file";
  var accessToken = User.tokenValue;
  // "123.e43ff8240ee3320515b0e4d839e00cd8.Y7318QwBaPQMoOV130rjpHJWxK8Gi4KXJBgD0nQ.0jNWnw";

//  http请求
  Future<BdDiskUser> getUserInfo() async {
    var request = await httpClient.getUrl(Uri.https(host, userInfoPath, {
      'method': 'uinfo',
      'access_token': accessToken,
    }));

    var response = await request.close();
    var respText = await response.transform(Utf8Decoder()).join(); //解码，返回json
    var jsonMap = json.decode(respText);

    return BdDiskUser.fromJson(jsonMap);
  }

  Future<DiskQuota> getDiskQuota() async {
    var request = await httpClient.getUrl(Uri.https(host, diskQuotaPath, {
      'access_token': accessToken,
    }));
    var response = await request.close();
    var respText = await response.transform(Utf8Decoder()).join(); //解码，返回json
    var jsonMap = json.decode(respText);
    return DiskQuota.fromJson(jsonMap);
  }

  Future<List<BdDiskFile>> getListFile(
    String dir, {
    String order = "name",
    int start = 0,
    int limit = 100,
  }) async {
    var request = await httpClient.getUrl(Uri.https(host, diskFilesPath, {
      'access_token': accessToken,
      'dir': dir,
      'method': 'list',
      'order': order,
      'start': start.toString(),
      'limit': limit.toString()
    }));

    var response = await request.close();
    var respText = await response.transform(Utf8Decoder()).join(); //解码，返回json
    var jsonMap = json.decode(respText);
    print(respText);
    List<BdDiskFile> files = [];
    if (jsonMap['errno'] != 0) return files;

    var listOfFiles = jsonMap['list'] as List;
    listOfFiles.forEach((json) => files.add(BdDiskFile.fromJson(json)));

    return files;
  }

  Future<Map<String, dynamic>> logout() async {
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(
        "https://openapi.baidu.com/rest/2.0/passport/auth/revokeAuthorization?access_token=${await accessToken}"));

    HttpClientResponse response = await request.close();

    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);
    return json;
  }

  Future<List<BdDiskFile>> getSearchFile(String key,
      {String dir = "/",
      int page = 1,
      int num = 1000,
      String recursion = '0',
      String web = '0'}) async {
    HttpClientRequest request =
        await httpClient.getUrl(Uri.http(host, diskFilesPath, {
      'method': "search",
      'access_token': await accessToken,
      'key': key,
      'num': '$num',
      'recursion': '$recursion',
      'page': '$page',
      'dir': dir,
      "web": web,
    }));

    HttpClientResponse response = await request.close();

    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);
    if (json["errno"] != 0) {
      throw Exception("diskFilePath error code ${json["errno"]}");
    }
    var list = (json["list"] as List<dynamic>);
    return list.map((e) => BdDiskFile.fromJson(e)).toList();
  }
}
