import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/user.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String url =
      "https://openapi.baidu.com/oauth/2.0/authorize?response_type=token&redirect_uri=oob&display=mobile&client_id=NqOMXF6XGhGRIGemsQ9nG0Na&scope=basic%20netdisk";

  ///font
  final _biggerFont =
      const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600);
  final _normalFont =
      const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);

  ///border
  final _borderRadius = BorderRadius.circular(6);

  ///attribute
  bool _obsecureText = true;
  bool _isEnableLogin = false;

  //控制账户和密码的输入，获取其内容
  final accountController = TextEditingController();
  final pwdController = TextEditingController();
  //获取，将数据持久化到磁盘中
  Future<SharedPreferences> _pres = SharedPreferences.getInstance();

  @override
  void initState() {
    _pres.then((d) {
      accountController.text = d.getString(User.accountKey);
      pwdController.text = d.getString(User.passwordKey);
      _checkUserInput();
    });
    super.initState();

    // Enable hybrid composition.
    if (Platform.isAndroid) {
      print("安卓");
      WebView.platform = SurfaceAndroidWebView();
    }
  } // 提示框

  // 1.确认按钮
  Widget _confirm() {
    // ignore: deprecated_member_use
    return FlatButton(
      color: Colors.blue,
      child: Text(
        "确认",
        style: _normalFont,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (context) => new MyHomePage()),
        );
      },
    );
  }

  // 2.取消按钮
  Widget _cancel() {
    // ignore: deprecated_member_use
    return FlatButton(
      color: Colors.blue,
      child: Text(
        "取消",
        style: _normalFont,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  ///登录按钮
  _getLoginButtonPressed() {
    if (!_isEnableLogin) return null;

    return () async {
      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              title: Text("登录提醒"),
              content: Text(
                  "登录账户:${accountController.text} \n登录密码： ${pwdController.text}"),
              actions: <Widget>[
                _confirm(),
                _cancel(),
              ],
            );
          });
      //写入时可以不是异步的，但是读取必须等待其读取完成
      final SharedPreferences pres = await _pres;
      pres.setString(User.accountKey, accountController.text);
      pres.setString(User.passwordKey, pwdController.text);
    };
  }

  /// 检查用户输入
  void _checkUserInput() {
    if (accountController.text.isNotEmpty && pwdController.text.isNotEmpty) {
      if (_isEnableLogin) return;
    } else {
      if (!_isEnableLogin) return;
    }
    setState(() {
      _isEnableLogin = !_isEnableLogin;
    });
  }

  /// 渲染顶部
  Widget _buildTop() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/baiduLogo.png"),
          Text(
            "欢迎登录百度网盘",
            style: _biggerFont,
          ),
        ],
      ),
    );
  }

  /// 渲染账户输入框
  Widget _buildAccountEditTextField() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
      child: TextField(
        controller: accountController,
        onChanged: (text) => {
          _checkUserInput(),
        },
        decoration: InputDecoration(
          hintText: "请输入手机号/用户名/邮箱",
          filled: true,
          fillColor: Color.fromARGB(255, 240, 240, 240),
          contentPadding: EdgeInsets.only(left: 10),
          border: OutlineInputBorder(
              borderRadius: _borderRadius, borderSide: BorderSide.none),
        ),
      ),
    );
  }

  /// 渲染密码输入框
  Widget _buildPwdEditTextField() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 25, right: 25),
      child: TextField(
        controller: pwdController,
        onChanged: (text) => {
          _checkUserInput(),
        },
        style: _normalFont,
        obscureText: _obsecureText,
        decoration: InputDecoration(
            hintText: "请输入登录密码",
            filled: true,
            fillColor: Color.fromARGB(255, 240, 240, 240),
            contentPadding: EdgeInsets.only(left: 10),
            border: OutlineInputBorder(
                borderRadius: _borderRadius, borderSide: BorderSide.none),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obsecureText = !_obsecureText),
              icon: Image.asset(
                _obsecureText ? 'assets/closeEye.png' : 'assets/openEye.png',
                width: 20,
                height: 20,
              ),
              splashColor: Colors.transparent, //去掉点击阴影效果
              highlightColor: Colors.transparent, //去掉点击阴影效果
            )),
      ),
    );
  }

  /// 渲染登录按钮
  Widget _buildButtonLogin() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 25, right: 25),
        width: MediaQuery.of(context).size.width,
        height: 45,
        // ignore: deprecated_member_use
        child: RaisedButton(
          child: Text(
            "登录",
            style: _normalFont,
          ),
          color: Colors.blue,
          disabledColor: Colors.black12,
          textColor: Colors.white,
          disabledTextColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: _borderRadius),
          onPressed: _getLoginButtonPressed(),
        ));
  }

  /// 界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //脚手架
      appBar: AppBar(
        title: Text(
          "登录",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTop(),
              _buildAccountEditTextField(),
              _buildPwdEditTextField(),
              _buildButtonLogin()
            ],
          ),
        ),
      ),
    );
  }
}
