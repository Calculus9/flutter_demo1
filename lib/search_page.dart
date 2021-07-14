import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/search_input_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textController =
      TextEditingController(); // 文本控制器  用于清空文本框

  List<String> hisList = new List(); // 存储历史记录的列表

  List<SearchHistoryWidget> widgetList = new List(); // 存储SearchHistoryWidget的列表

  @override
  void initState() {
    // 读取本地存储的历史记录 并显示
    _getHistory();
    super.initState();
  }

  @override
  void dispose() {
    print("组件销毁");
    _saveHistory();
    super.dispose();
  }

  //获取本地存储的历史记录
  void _getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hisList = prefs.getStringList('hisList') ?? [];
      showHistory(hisList);
    });
  }

  //将当前的历史记录存储进本地
  void _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("hisList", hisList);
  }

  // 搜索框提交事件
  void _onSubmittedSearch(value) {
    //搜索文件
    searchFile(value);
    //添加到历史记录
    addToHistory(value);
  }

  // 文件搜索
  void searchFile(value) {}

  // 添加到历史记录
  void addToHistory(value) {
    setState(() {
      _textController.clear(); // 清空文本框
      hisList.add(value);
      showHistory(hisList); // 展示列表文件
    });
  }

  //展示历史记录
  void showHistory(list) {
    widgetList.clear();
    list.forEach((element) {
      widgetList.add(SearchHistoryWidget(
        UniqueKey(),
        title: element,
        deleteWidget: (v) {
          //v 是待删除组件的title
          setState(() {
            hisList.remove(v.title);
            print(hisList);
            showHistory(hisList);
          });
        },
      ));
    });
  }

  // 清空历史记录文本
  Widget _clearHistoryText() {
    return Container(
      alignment: Alignment(0, -1),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          InkWell(
            child: Text(
              "清空历史记录",
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
            onTap: () {
              print("清空历史记录");
              setState(() {
                hisList.clear();
                widgetList.clear();
              });
            },
          )
        ],
      ),
    );
  }

  // 搜索文本框
  Widget _searchTextField() {
    return Row(
      children: [
        Expanded(
          child: SearchInputWidget(
            onSubmitted: _onSubmittedSearch,
            textController: _textController,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: InkWell(
            child: Text(
              "取消",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  // 搜索历史文本框
  Widget _searchHistoryText() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      alignment: Alignment(-1, 0),
      child: Text(
        "搜索历史",
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w900, color: Colors.black),
      ),
    );
  }

  // 搜索历史列表
  Widget _searchHistoryBody() {
    return SingleChildScrollView(
      child: Column(
        children: widgetList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(children: [
        SizedBox(
          height: 25,
        ),
        _searchTextField(),
        SizedBox(
          height: 10,
        ),
        _searchHistoryText(),
        _searchHistoryBody(),
        Spacer(), // 相当于弹簧效果,只有在不可以滑动的时候,弹簧才有效果
        _clearHistoryText(),
      ]),
    ));
  }
}

typedef DeleteWidgetCallback = void Function(SearchHistoryWidget widget);

//自定义历史记录组件
class SearchHistoryWidget extends StatefulWidget {
  final String title;

  final DeleteWidgetCallback deleteWidget;

  //实现删除组件的功能，key是必要的
  SearchHistoryWidget(Key key, {this.title, @required this.deleteWidget})
      : super(key: key);

  @override
  _SearchHistoryWidgetState createState() =>
      _SearchHistoryWidgetState(this.title);
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  String title;

  _SearchHistoryWidgetState(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print(this.title);
        },
        child: Row(
          children: [
            Container(
              child: IconButton(
                icon: Icon(Icons.restore),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: Text(this.title),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.deleteWidget(widget);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
