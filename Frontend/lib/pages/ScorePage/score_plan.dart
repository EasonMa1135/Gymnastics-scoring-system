import 'package:dance_scoring/pages/ScorePage/score_for_all.dart';
import 'package:dance_scoring/pages/ScorePage/score_history.dart';
import 'package:dance_scoring/pages/ScorePage/score_upload.dart';
import 'package:flutter/material.dart';
import 'package:dance_scoring/pages/ScorePage/score_give.dart';

import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';

class PlanPage extends StatefulWidget {
  static const String routeName = "/plan-page";
  const PlanPage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<PlanPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  var sel_video = null;
  var TestState = ValueNotifier<String>('未选择视频');

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    var PH = MediaQuery.of(context).size.height;
    var PW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  title: Text('默认评测计划'),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScoreUploadPage(
                                  key: UniqueKey(),
                                ),settings: RouteSettings(arguments: user),));
                  },
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Text('查看评测历史'),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(
                            key: UniqueKey(),
                          ),
                          settings: RouteSettings(arguments: user),
                        ));
                  },
                ),
                Visibility(
                  visible: user.user_identity <= 1,
                  child: Divider(
                    height: 0,
                    color: Colors.grey[300],
                  ),
                ),

                Visibility(
                  visible: user.user_identity <= 1,
                  child: ListTile(
                    title: Text('为学员评分'),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TAScorePage(
                              key: UniqueKey(),
                            ),settings: RouteSettings(arguments: user),));
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => ScorePage()));
                    },
                  ),

                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
