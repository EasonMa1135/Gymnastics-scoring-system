import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dance_scoring/utils/user_info.dart';
import '../ScorePage/score_plan.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:dance_scoring/Pages/UserPage/user_drawer.dart';
import 'package:dance_scoring/Pages/HomePage/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../TuitionPage/tuition_recommend.dart';


class UserPage extends StatefulWidget {
  static const String routeName = "/user";
  const UserPage({Key? key}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 在Flutter中的每一个类都是一个控件
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        //用DefaultTabController包围,使每一个Tabbar都能对应一个页面
        appBar: PreferredSize(
            child: AppBar(
              title: Text("智慧舞蹈"),
              centerTitle: true, //居中
              actions: <Widget>[
                //右侧行为按钮
                IconButton(
                  color: Colors.black,
                  onPressed: null,
                  icon: Icon(Icons.cast),
                )
              ],
            ),
            preferredSize: Size.fromHeight(45)),

        drawer: UserDrawer(),

        bottomNavigationBar: Container(
          //底部导航栏
          //美化
          decoration: BoxDecoration(
            color: CustomTheme.colorBlueText,
            borderRadius: BorderRadius.circular(3),
          ),
          height: 60, //一般tabbar的高度为50
          child: TabBar(
            labelStyle: TextStyle(height: 0, fontSize: 12),
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 20.0,
                ),
                text: "首页",
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.play,
                  size: 20.0,
                ),
                text: "我要教学",
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 20.0,
                ),
                text: "我要评测",
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.music,
                  size: 20.0,
                ),
                text: "我要音乐",
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: <Widget>[
            //每页填充文字
            Center(
              child: HomePage(),
            ),
            Center(
              child: RecommendPage(),
            ),
            Center(
              child: PlanPage(),
            ),
            Center(
              child: Text('我要音乐'),
            ),
          ],
        ),
      ),
    );
  }
}