import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/main.dart';
import 'package:flutter_demo1/personal_center.dart';
import 'package:flutter_demo1/user.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bd_disk/bd_oauth2_token.dart';
import 'login_page.dart';

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

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 检查是否有权限
  checkPermission() async {
    // 检查是否已有读写内存的权限
    bool status = await Permission.storage.isGranted;

    //判断如果还没拥有读写权限就申请获取权限
    if (!status) {
      return await Permission.storage.request().isGranted;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkPermission();
    return MaterialApp(
        title: "Baidu Disk",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/person': (context) => PersonalCenter(),
          // 'arch':(context)=>SearchPage()
        },
        // home:LoginPage());
        home: Temp());
  }
}

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  final String url =
      "https://openapi.baidu.com/oauth/2.0/authorize?response_type=token&redirect_uri=oob&display=mobile&client_id=NqOMXF6XGhGRIGemsQ9nG0Na&scope=basic%20netdisk";

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      _checkOAuth2Result(context, url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: "${this.url}",
      appBar: new AppBar(
        centerTitle: true, // 标题居中
        title: new Text("百度账号授权登录"),
      ),
    );
  }

  // 首页检查token
  _checkOAuth2Result(BuildContext context, String url) async {
    //替换第一次出现#字符位置的字符
    url = url.replaceFirst('#', '?');
    Uri uri = Uri.parse(url);
    if (uri == null) return;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    if (uri.pathSegments.contains('login_success') &&
        uri.queryParameters.containsKey('access_token')) {
      var prefs = await _prefs;
      String expiresIn = uri.queryParameters['expires_in'] ?? "0";
      var token = BdOAuth2Token(uri.queryParameters['access_token'],
          expiresIn: int.parse(expiresIn));
      prefs.setJson(User.keyBdOAuth2Token, token.toJson());
      User.tokenValue = prefs.getJson(User.keyBdOAuth2Token)["access_token"];
      print(User.tokenValue);
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
