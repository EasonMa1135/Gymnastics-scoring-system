import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:dance_scoring/utils/get_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dance_scoring/Pages/UserPage/AdminPage/admin_page.dart';
import 'package:dance_scoring/Pages/UserPage/InfoPage/info_page.dart';
import 'package:dance_scoring/Pages/UserPage/InfoPage/show_page.dart';
import '../../../utils/BackendSetting.dart';
import 'dart:io';


class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    return Drawer(
      child: Container(
      //加个背景
        //color: 设置整个的color
        child: ListView(
          //一个列表// 抽屉可能在高度上超出屏幕，所以使用 ListView 组件包裹起来，实现纵向滚动效果
          // 干掉顶部灰色区域
          padding: EdgeInsets.all(0),
          children: <Widget>[
            SizedBox(
              height: 135.0,
              child: DrawerHeader(
              padding: EdgeInsets.zero, /* padding置为0 */
              child: new Stack( children: <Widget>[ /* 用stack来放背景图片 */
                new Image.asset(
                  Assets.assets_person_background,
                  fit: BoxFit.fill, width: double.infinity,),
                new Align(/* 先放置对齐 */
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    height: 70.0,
                    margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: FileImage(File(Assets.avatarPath == "" ? Assets.assets_login_logo: Assets.avatarPath)),
                          radius: 35.0,),
                        new SizedBox(width: 10),
                        new Container(
                          margin: EdgeInsets.only(left: 6.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                            mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                            children: <Widget>[
                              new Text(user.user_name, style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),),
                              new Text("Lv" + user.user_level.toString() + ",   " + user.user_exp.toString() + "/" + user.getExp().toString(),
                                style: new TextStyle(fontSize: 14.0, color: Colors.white),),
                            ],
                          ),
                        ),
                      ],),
                  ),
                ),
              ]),
            )),

            GestureDetector(
              onTap:() {
                Navigator.push(context, MaterialPageRoute( builder: (context) => InfoPage()));
              },
              child: ListTile(
                title: Text('个人信息'),
                trailing: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ),

            Divider(),
            ListTile(
              title: Text('我的钱包'),
              trailing: Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
            Divider(),

            GestureDetector(
              onTap:() async{
                UserInfo userQuery = await queryUserByID(user.user_id);
                Navigator.push(context, MaterialPageRoute( builder: (context) => ShowPage(user: userQuery)));
              },
              child: ListTile(
                title: Text('我的会员'),
                trailing: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ),

            Divider(),
            ListTile(
              title: Text('系统设置'),
              trailing: Icon(
                Icons.settings,
                color: Colors.green,
              ),
            ),
            Divider(),

            Visibility(
              visible: user.user_identity == 0,
              child: GestureDetector(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => AdminPage()));
                },
                child: ListTile(
                  title: Text('管理员界面'),
                  trailing: Icon(
                    Icons.supervisor_account_outlined,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: user.user_identity == 0,
              child: Divider(),
            ),

            GestureDetector(
              onTap: () async {
                await _logout();
              },
              child: ListTile(
                title: Text('注销'),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: Colors.amberAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    // 弹出确认对话框
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('确认注销？'),
          actions: <Widget>[
            TextButton(
              child: Text('确定'),
              onPressed: () async {
                // 清除用户数据
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("userData");
                Assets.avatarPath = "";
                UserInfoContainer.of(context)!.setUserInfo(UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0)));
                // 关闭当前对话框和用户页面

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // 跳转到登录页面
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

