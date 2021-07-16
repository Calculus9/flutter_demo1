// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo1/datebase_helper.dart';
// import 'package:flutter_demo1/file/disk_file.dart';
// import 'package:flutter_demo1/file/file_store.dart';
// import 'package:flutter_demo1/search/search_history.dart';
// import 'package:flutter_demo1/search/search_history_widget.dart';
//
// class SearchPage extends StatefulWidget {
//   DbHelper searchHistoryProvider = DbHelper.instance;
//   FileStore fileStore;
//   String currPath;
//
//   SearchPage(this.fileStore, {this.currPath});
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// enum SearchState { typeing, loading, done, empty, fail }
//
// class _SearchPageState extends State<SearchPage> {
//   List<SearchHistory> _historyWords = [];
//   var _searchKeyword;
//   var _searchState = SearchState.typeing;
//   List<DiskFile> _searchResult = [];
//
//   void _onSearchHistoryEvent(SearchHistoryEvent event, SearchHistory history) {
//     switch (event) {
//       case SearchHistoryEvent.insert:
//         widget.searchHistoryProvider
//             .insert(history)
//             .then((value) => setState(() {
//                   history.id = value;
//                   _historyWords.insert(0, history);
//                 }))
//             .catchError((e) {});
//         break;
//       case SearchHistoryEvent.delete:
//         widget.searchHistoryProvider
//             .delete(history.id)
//             .then((value) => setState(() => _historyWords.remove(history)));
//         break;
//       case SearchHistoryEvent.clear:
//         widget.searchHistoryProvider
//             .deleteAll()
//             .then((value) => setState(() => _historyWords.clear()));
//         break;
//       case SearchHistoryEvent.search:
//         _onSubmittedSearchWord(history.keyword);
//     }
//   }
//
//   @override
//   void initState() {
//     widget.searchHistoryProvider
//         .queryAll()
//         .then((list) => setState(() => _historyWords = list));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.only(top: 40),
//         padding: EdgeInsets.only(left: 16, right: 16),
//         child: Column(
//           children: <Widget>[
//             _buildSearchInput(),
//             Container(height: 15),
//             _buildPageBody(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPageBody() {
//     switch (_searchState) {
//       case SearchState.typeing:
//         return _buildSearchHistory();
//       case SearchState.loading:
//         return _buildLoadingWidget();
//       case SearchState.done:
//         return _buildSearchResult();
//       case SearchState.fail:
//       case SearchState.empty:
//         return null;
//     }
//   }
//
//   void _onSubmittedSearchWord(String value) {
//     value = value.trim();
//     if (value.isEmpty) return;
//     setState(() => _searchState = SearchState.loading);
//   }
//
//   void _onOpenFile(DiskFile file) {
//     if (0 == file.isDir) return;
//   }
//
//   void _onSearchTextChanged(String value) {
//     setState(() {
//       _searchKeyword = value.trim();
//       _searchState = SearchState.typeing;
//     });
//   }
//
//   Widget _buildSearchHistory() {
//     return Expanded(
//         child: Column(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             Text(
//               "搜索历史",
//               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//         Expanded(
//             child: SearchHistoryWidget(
//           _historyWords,
//           searchKeyWord: _searchKeyword,
//           eventCallback: _onSearchHistoryEvent,
//         ))
//       ],
//     ));
//   }
//
//   Widget _buildLoadingWidget() {
//     return Center(
//       heightFactor: 6,
//       child: Column(
//         children: <Widget>[
//           CircularProgressIndicator(
//             strokeWidth: 4.0,
//           ),
//           Text("正在搜索")
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSearchResult() {
//     return Expanded(
//         child: Column(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             Text(
//               "搜索结果(${_searchResult.length})",
//               style: TextStyle(color: Colors.blue, fontSize: 12),
//             )
//           ],
//         ),
//       ],
//     ));
//   }
//   Widget _buildSearchInput()
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/search/search_history_widget.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
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
              Navigator.of(context).pop();
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

