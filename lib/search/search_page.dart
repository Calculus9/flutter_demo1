import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/datebase_helper.dart';
import 'package:flutter_demo1/file/disk_file.dart';
import 'package:flutter_demo1/file/file_list_widget.dart';
import 'package:flutter_demo1/file/file_page.dart';
import 'package:flutter_demo1/file/file_store.dart';
import 'package:flutter_demo1/search/search_history.dart';
import 'package:flutter_demo1/search/search_history_widget.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
import 'package:flutter_demo1/system/system_file_store.dart';

enum SearchState { typing, loading, fail, done, empty }

class SearchPage extends StatefulWidget {
  //用于搜索文件
  FileStore _fileStore = SystemFileStore();
  String currPath;
  SearchPage(this._fileStore,{this.currPath});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //数据库
  DbHelper provider = DbHelper.instance;

  List<SearchHistory> historyList = [];

  // 文本控制器  用于清空文本框
  TextEditingController _textController = TextEditingController();

  // 存储SearchHistoryWidget的列表
  List<SearchHistoryWidget> widgetList = [];

  List<DiskFile> _diskFiles = [];

  //状态
  var _state = SearchState.typing;

  @override
  void initState() {
    //查询所有
    Future<List<SearchHistory>> listHistoryFuture = provider.queryAll();
    // 将查询到的list展示
    listHistoryFuture.then((value) {
      setState(() {
        this.historyList = value;
        showHistory(value);
      });
    });
    _state = SearchState.typing;
    super.initState();
  }

  // 搜索框提交事件
  //搜索框提交事件后，当前searchState切换为loading
  void _onSubmittedSearch(value) {
    if (value == '') return;
    setState(() {
      _state = SearchState.loading;
    });
    _textController.clear(); // 清空文本框

    //搜索文件
    searchFile(value);
    //添加到历史记录
    SearchHistory tmp = SearchHistory(value);
    tmp.id = DateTime.now().millisecondsSinceEpoch;
    tmp.time = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _textController.clear(); // 清空文本框
      historyList.add(tmp);
    });
    //添加到数据库
    provider.deleteAll();
    showHistory(historyList); // 展示列表文件
    historyList.forEach((element) async {
      await provider.insert(element);
    });
  }

  // 文件搜索
  void searchFile(value) {
    setState(() {
      _state = SearchState.loading;
    });
    // 搜索本地文件里面是否包含，之根据搜索所有本地文件去找
    widget._fileStore
        .search(value, path: widget.currPath, recursion: 1)
        .then((files) {
      setState(() {
        _diskFiles = files;
        _state = SearchState.done;
      });
    }).catchError((error) {
      setState(() {
        _state = SearchState.fail;
      });
    });
  }

  //展示历史记录
  void showHistory(list) {
    widgetList.clear();
    list.forEach((element) {
      widgetList.add(SearchHistoryWidget(
        UniqueKey(),
        title: element.keyword,
        deleteWidget: (v) {
          //v 是待删除组件的title
          setState(() {
            for (int i = 0; i < historyList.length; i++) {
              if (historyList[i].keyword == v.title) {
                historyList.removeAt(i);
                break;
              }
            }
            showHistory(historyList);
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
              setState(() {
                // hisList.clear();
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
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  //加载页面
  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 300),
          CircularProgressIndicator(strokeWidth: 4.0),
          Text("正在加载")
        ],
      ),
    );
  }

  void _onDiskFileTap(DiskFile file) {
    //打开文件
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FilePage(rootpath: file.path,allowPop: true,)));
  }

  /// 根据搜索切换不同的状态
  Widget _buildPageBody() {
    switch (_state) {
      // 搜索的时候显示之前的搜索历史
      case SearchState.typing:
        return _searchHistoryBody();
      case SearchState.loading:
        return _buildLoading();
      case SearchState.done:
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListTile(
                title: Text(
                  "搜索结果 (${_diskFiles.length})",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 300,
                child: FileListWidget(_diskFiles, _onDiskFileTap),
              ),
            ],
          ),
        );
      case SearchState.fail:
      case SearchState.empty:
        return Column(
          children: <Widget>[
            SizedBox(height: 200),
            IconButton(
              icon: Icon(Icons.refresh),
              iconSize: 96,
              onPressed: () {
                print("SearchState.fail");
              },
            ),
            Text("搜索失败")
          ],
        );
      default:
        return _searchHistoryBody();
    }
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
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          _searchTextField(),
          _buildPageBody()
        ]),
      ),
    ));
  }
}

typedef DeleteWidgetCallback = void Function(SearchHistoryWidget widget);
