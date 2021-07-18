import 'dart:convert';

import 'package:flutter_demo1/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import 'bd_disk_user.dart';
import 'bddisk_api_client.dart';

extension SharedPreferencesExtension on SharedPreferences {
  Future<bool> setJson(String key, Map<String, dynamic> json) {
    assert(json != null);
    assert(key != null);

    var value = jsonEncode(json);
    return this.setString(key, value);
  }

  Map<String, dynamic> getJson(String key) {
    assert(key != null);

    var value = this.getString(key);
    var json = jsonDecode(value);
    return json;
  }
}

//数据仓储管 理类
class UserRepository {
  final BdDiskApiClient apiClient;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserRepository({BdDiskApiClient apiClient})
      : this.apiClient = apiClient ?? BdDiskApiClient();

  /// 获取用户信息，网络异常时，返回缓存信息
  Future<BdDiskUser> getUserInfo() async {
    BdDiskUser user;
    var prefs = await _prefs;

    try {
      user = await apiClient.getUserInfo();
    } catch (e) {
      if (prefs.containsKey(User.keyUserInfo))
        return BdDiskUser.fromJson(prefs.getJson(User.keyUserInfo));
      return null;
    }
    prefs.setJson(User.keyUserInfo, user.toJson());
    return user;
  }
  // Future<Map<String, dynamic>> logout() async {
  //   var prefs = await _prefs;
  //
  //   // 请求百度接口，销毁 token
  //   Map response = await apiClient.logout();
  //
  //   // 清除本地保存的数据
  //   prefs.remove(User.keyBdOAuth2Token);
  //   prefs.remove(User.keyDiskQuota);
  //   prefs.remove(User.keyUserInfo);
  //
  //   // 移除 token
  //   AppConfig.instance.setToken(null);
  //   return response;
  // }
}
