import 'package:flutter/material.dart';
import 'package:flutter_demo1/file/file_page.dart';
import 'package:flutter_demo1/personal_center.dart';

import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedIndex = 0; // 当前page
//底部导航栏items
  final List<BottomNavigationBarItem> bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.archive), label: "文件"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
  ];
  final pages = [FilePage(), PersonalCenter()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
