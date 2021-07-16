// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_demo1/search/search_history.dart';
//
// enum SearchHistoryEvent { insert, delete, clear, search }
// typedef OnSearchHistoryEventCallback = void Function(
//     SearchHistoryEvent event, SearchHistory history);
//
// class SearchHistoryWidget extends StatefulWidget {
//   List<SearchHistory> historyWords = [];
//   var searchKeyWord;
//
//   OnSearchHistoryEventCallback eventCallback;
//
//   SearchHistoryWidget(this.historyWords,
//       {this.searchKeyWord, this.eventCallback});
//
//   @override
//   _SearchHistoryWidgetState createState() => _SearchHistoryWidgetState();
// }
//
// class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
//   List<SearchHistory> _historyWords = [];
//
//   @override
//   void initState() => _refreshSearchHistory();
//
//   void _refreshSearchHistory() {
//     _historyWords = widget.historyWords.toList();
//     if (widget.searchKeyWord != null && widget.historyWords.isNotEmpty)
//       _historyWords.retainWhere((test) => test.keyword
//           .toLowerCase()
//           .contains(widget.searchKeyWord.toString().toLowerCase()));
//   }
//
//   void _sendEvent(SearchHistoryEvent event, SearchHistory history) {
//     if (widget.eventCallback != null) widget.eventCallback(event, history);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//             child: ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: _historyWords.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return _buildHistoryItem(index);
//                 })),
//         Center(
//           child: FlatButton(
//             child: new Text(
//               "清空历史记录",
//               style: TextStyle(color: Colors.blue),
//             ),
//             onPressed: () => _sendEvent(SearchHistoryEvent.clear, null),
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//           ),
//         )
//       ],
//     );
//   }
//
//   @override
//   void didUpdateWidget(SearchHistoryWidget oldWidget) {
//     return _refreshSearchHistory();
//   }
//
//   Widget _buildHistoryItem(int index) {
//     return InkWell(
//       child: Container(
//         alignment: Alignment.center,
//         child: ListTile(
//           leading: Icon(Icons.history),
//           title: Text(_historyWords[index].keyword),
//           trailing: IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () =>
//                 _sendEvent(SearchHistoryEvent.delete, _historyWords[index]),
//           ),
//         ),
//       ),
//       onTap: () => _sendEvent(SearchHistoryEvent.search, _historyWords[index]),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/search/search_input_widget.dart';
import 'package:flutter_demo1/search/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
