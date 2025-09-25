import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:dance_scoring/utils/BackendSetting.dart';

class ShowPage extends StatefulWidget {
  final UserInfo user;
  const ShowPage({Key? key, required this.user}) : super(key: key);
  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(child: Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pink, Colors.purple],
              )),
            child: Column(children:[
              SizedBox(height: 60),
              Row(children: [
                SizedBox(width: 30),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundImage: FileImage(File("${Assets.tempDir}/${widget.user.user_avatar}")),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(widget.user.user_name, style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'PingFang SC')),
                        SizedBox(width: 20),
                        Container(
                          padding: EdgeInsets.all(2),   // 设置内边距
                          decoration: BoxDecoration(
                            color: Colors.red,   // 设置背景色
                            borderRadius: BorderRadius.circular(4),   // 设置圆角
                          ),
                          child: Text(
                            "Lv" + widget.user.user_level.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'PingFang SC'),
                          ),
                        ),],
                    ),
                    SizedBox(height: 5),
                    Text("所在地: " + widget.user.user_province + ((widget.user.user_city == "未知" || widget.user.user_city == "市辖区") ? "" : widget.user.user_city), style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'PingFang SC')),
                    SizedBox(height: 5),
                    Text(
                      (widget.user.user_identity <= 2? "认证身份：" + widget.user.getLoginIdentity(): "明星认证:" + widget.user.verify_name), //todo 明星认证名字
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],),
              Container(
                margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                color: Colors.transparent,
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,   // 将 Card 的 elevation 属性设置为 0
                  child: Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNumberTextWidget(widget.user.learn_times.toString(), '学习次数'),
                        _buildNumberTextWidget(widget.user.eval_times.toString(), '评测次数'),
                        _buildNumberTextWidget(widget.user.share_times.toString(), '分享次数'),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),),
          Expanded(child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('教学视频'),
                  leading: Icon(
                    FontAwesomeIcons.play,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('评测视频'),
                  leading: Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('收藏视频'),
                  leading: Icon(
                    FontAwesomeIcons.heart,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('音乐列表'),
                  leading: Icon(
                    FontAwesomeIcons.music,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('备用'),
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('备用'),
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap:() {},
                child: ListTile(
                  title: Text('备用'),
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ),
            ]
          ),),
        ],
      ),
    );
  }

  Widget _buildNumberTextWidget(String number, String text) { //todo 按钮跳转
   return TextButton(
      child: Column(children: [
        Text(number, style: TextStyle(fontSize: 30, color: Colors.white)),
        Text(text, style: TextStyle(color: Colors.white)),
      ]),
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30)),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),),
      onPressed: () {}
    );
  }
}
