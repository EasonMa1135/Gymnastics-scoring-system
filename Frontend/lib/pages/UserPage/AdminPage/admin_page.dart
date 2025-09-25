import 'package:dance_scoring/pages/UserPage/AdminPage/tuition_setting.dart';
import 'package:flutter/material.dart';
import 'package:dance_scoring/Pages/UserPage/AdminPage/identity_change.dart';
import 'package:dance_scoring/Pages/UserPage/AdminPage/verify_processing.dart';
import 'package:dance_scoring/Pages/UserPage/AdminPage/star_recommend.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('管理员界面'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          InkWell(
            onTap:() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return IdentityChangePage();
                  }
              );
            },
            child: ListTile(
              title: Text('用户身份变更'),
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyProcessing()));
            },
            child: ListTile(
              title: Text('明星认证处理'),
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StarRecommendPage()));
            },
            child: ListTile(
              title: Text('明星推荐位更改'),
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap:() async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
            },
            child: ListTile(
              title: Text('教学管理'),
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
      ),
    );
  }
}