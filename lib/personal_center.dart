import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo1/bd_disk/bddisk_api_client.dart';
import 'package:flutter_demo1/bd_disk/user_repository.dart';
import 'package:flutter_demo1/utils.dart';

import 'bd_disk/bd_disk_user.dart';

class PersonalCenter extends StatefulWidget {
  @override
  _PersonalCenterState createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  UserRepository userRepository;
  String _avatar_url;
  var _username;
  int _used = 1, _total = 1;
  String _quota_des = "";
  int _vip_type = 0;

  /// 数据列表
  List listData = [
    {"imgUrl": "assets/file_add_btn_scan.png", "text": "扫一扫"},
    {"imgUrl": "assets/file_add_btn_photo.png", "text": "上传\n图片"},
    {"imgUrl": "assets/file_add_btn_video.png", "text": "上传\n视频"},
    {"imgUrl": "assets/file_add_btn_note.png", "text": "新建\n笔记"},
    {"imgUrl": "assets/file_add_btn_file.png", "text": "上传\n文档"},
    {"imgUrl": "assets/file_add_btn_music.png", "text": "上传\n音乐"},
    {"imgUrl": "assets/file_add_btn_folder.png", "text": " 新建\n文件夹"},
    {"imgUrl": "assets/file_add_btn_other.png", "text": "上传\n文件"},
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
        child: FadeInImage.assetNetwork(
          placeholder: "assets/user-head.jpg",
          image: _avatar_url == null
              ? "https://bpic.588ku.com/element_origin_min_pic/17/06/13/5c5a1442f0ec72e59829ee10d891f224.jpg"
              : _avatar_url,
          width: 60,
          height: 60,
        ),
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
          "$_username",
          style: TextStyle(fontSize: 20.0, color: Colors.grey),
        ),
        SizedBox(width: 5.0),
        Container(
          child: Image.asset("assets/user-level$_vip_type.png"),
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
          value: _used * (1.0) / _total,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
    );
  }

  //内存消耗
  Widget _headerRight() {
    return Container(
      alignment: Alignment(-1, 0),
      child: Text(
        "$_quota_des",
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
          width: 15.0,
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
        // padding: EdgeInsets.only(bottom: 30),
        crossAxisCount: 4, // 控制一行widget的数量
        childAspectRatio: 0.6, // 宽度和高度的比例
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
              height: 60.0,
            ),
            _personalHeader(),
            // _exit(),
            _gridViewList(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var apiClient = BdDiskApiClient();
    apiClient.getUserInfo().then((user) {
      setState(() {
        _avatar_url = user.avatarUrl;
        _username = user.baiduName;
        _vip_type = user.vipType;
      });
    });
    apiClient.getDiskQuota().then((quota) {
      setState(() {
        _used = quota.used;
        _total = quota.total;
        _quota_des = Utils.getFileSize(_used) + "/" + Utils.getFileSize(_total);
      });
    });
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
