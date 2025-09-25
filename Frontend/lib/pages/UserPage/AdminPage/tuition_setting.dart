import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';
import 'package:dance_scoring/utils/tuition_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../utils/BackendSetting.dart';
import '../../../utils/user_info.dart';
import '../../../utils/user_info_container.dart';
import 'TuitionManagePage/DanceCategoryManage.dart';
import 'TuitionManagePage/RecommendManagePage.dart';
import 'TuitionManagePage/TuitionManagePage.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = "/setting-page";
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: Text('教学管理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
          children: <Widget>[
            InkWell(
              onTap:() async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendManagePage()));
              },
              child: ListTile(
                title: Text('推荐位管理'),
                leading: Icon(
                  Icons.recommend,
                  color: Colors.blue,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap:() async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DanceManagePage()));
              },
              child: ListTile(
                title: Text('分类管理'),
                leading: Icon(
                  Icons.category,
                  color: Colors.blue,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap:() async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TuitionManagePage()));
              },
              child: ListTile(
                title: Text('课程管理'),
                leading: Icon(
                  Icons.play_lesson,
                  color: Colors.blue,
                ),
              ),
            ),
            Divider(),
    ]
      ),
    );
  }

}