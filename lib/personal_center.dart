import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalCenter extends StatefulWidget {
  @override
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  /// 数据列表
  List listData = [
    {"imgUrl": "assets/file_add_btn_scan.png", "text": "扫一扫"},
    {"imgUrl": "assets/file_add_btn_photo.png", "text": "上传图片"},
    {"imgUrl": "assets/file_add_btn_video.png", "text": "上传视频"},
    {"imgUrl": "assets/file_add_btn_note.png", "text": "新建笔记"},
    {"imgUrl": "assets/file_add_btn_file.png", "text": "上传文档"},
    {"imgUrl": "assets/file_add_btn_music.png", "text": "上传音乐"},
    {"imgUrl": "assets/file_add_btn_folder.png", "text": "新建文件夹"},
    {"imgUrl": "assets/file_add_btn_other.png", "text": "上传文件"},
  ];

  // 获取列表数据
  List<Widget> _getListData() {
    var list = listData.map((value) {
      return GridContent(value["imgUrl"], value["text"]);
    });

    return list.toList();
  }

  /// 头像
  Widget _headerLogo() {
    return Container(
      child: ClipOval(
        child: Image.asset("assets/user-head.jpg"),
      ),
      width: 80.0,
      height: 80.0,
    );
  }

  //名字
  Widget _headerLeft() {
    return Row(
      children: [
        Text(
          "移动开发",
          style: TextStyle(fontSize: 20.0, color: Colors.grey),
        ),
        SizedBox(width: 5.0),
        Container(
          child: Image.asset("assets/user-level0.png"),
          width: 25.0,
          height: 25.0,
        )
      ],
    );
  }

  //进度条
  Widget _headerMid() {
    return Container(
      width: 300.0,
      child: LinearProgressIndicator(
          backgroundColor: Colors.grey,
          value: 0.2,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
    );
  }

  //内存消耗
  Widget _headerRight() {
    return Container(
      alignment: Alignment(-1, 0),
      child: Text(
        "668GB/3220GB",
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
    );
  }

  // 个人中心头部
  Widget _personalHeader() {
    return Row(
      children: [
        _headerLogo(),
        SizedBox(
          width: 13.0,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_headerLeft(), _headerMid(), _headerRight()],
          ),
        )
      ],
    );
  }

  // 个人中心网格布局
  Widget _gridViewList() {
    return Container(
      child: GridView.count(
        crossAxisSpacing: 10, // 水平子 Widget 距离
        mainAxisSpacing: 10, // 垂直子 Widget 距离
        padding: EdgeInsets.all(10),
        crossAxisCount: 4, // 控制一行widget的数量
        childAspectRatio: 0.7, // 宽度和高度的比例
        children: this._getListData(),
      ),
      height: 500.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            _personalHeader(),
            SizedBox(
              height: 10.0,
            ),
            _gridViewList()
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GridContent extends StatelessWidget {
  /// 图片地址
  String imgUrl;

  ///图片内容
  String text;

  ///构造函数
  GridContent(this.imgUrl, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 240,
        height: 240,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Image.asset(this.imgUrl),
            ),
            Expanded(
              flex: 1,
              child: Text(
                this.text,
                style: TextStyle(fontSize: 12.0),
              ),
            )
          ],
        ));
  }
}
