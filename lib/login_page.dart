import 'package:flutter/material.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  String _accountText = "";
  String _pwdText = "";

  // 提示框
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

  ///按钮控件
  _getLoginButtomPressed() {
    if (!_isEnableLogin) return null;
    return () {
      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              title: Text("登录提醒"),
              content: Text("登录账户:$_accountText \n登录密码： $_pwdText"),
              actions: <Widget>[
                _confirm(),
                _cancel(),
              ],
            );
          });
    };
  }

  void _checkUserInput() {
    if (_accountText.isNotEmpty && _pwdText.isNotEmpty) {
      if (_isEnableLogin) return;
    } else {
      if (!_isEnableLogin) return;
    }
    setState(() {
      _isEnableLogin = !_isEnableLogin;
    });
  }

  /// 顶部
  Widget _buildTop() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset("assets/baiduLogo.png"),
          Text(
            "欢迎登录百度用户",
            style: _biggerFont,
          ),
        ],
      ),
    );
  }

  /// 账户输入框
  Widget _buildAccountEditTextField() {
    return Container(
      margin: EdgeInsets.only(top: 20,left: 25,right: 25),
      child: TextField(
        onChanged: (text) => {
          _accountText = text,
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

  ///密码输入框
  Widget _buildPwdEditTextField() {
    return Container(
      margin: EdgeInsets.only(top: 20,left: 25,right: 25),
      child: TextField(
        onChanged: (text) => {
          _pwdText = text,
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

  /// 登录按钮
  Widget _buildButtonLogin() {
    return Container(
        margin: EdgeInsets.only(top: 20,left: 25,right: 25),
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
          onPressed: _getLoginButtomPressed(),
        ));
  }

  /// 界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //脚手架
      appBar: AppBar(
        title: Text("登录"),
        centerTitle: true,
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
