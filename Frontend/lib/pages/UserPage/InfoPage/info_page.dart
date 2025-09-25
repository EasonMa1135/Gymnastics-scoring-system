import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/result_code.dart';
import 'package:json_bigint/json_bigint.dart';
import '../../../utils/BackendSetting.dart';

import './name_modify.dart';
import './password_modify.dart';
import './avatar_modify.dart';
import './star_verify.dart';

import 'package:flutter_pickers/pickers.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  void initState() {
    super.initState();
  }

  String sex = "";
  String initProvince = "", initCity = "", initTown = "";
  String password = "";
  UserInfo user = UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0));

  @override
  Widget build(BuildContext context) {
    user = UserInfoContainer.of(context)!.widget.user;
    sex = user.user_sex;
    initProvince = user.user_province;
    initCity = user.user_city;
    initTown = user.user_town;
    password = user.user_password;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '个人信息',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: ListView(
        children: [
          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Text("头像"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarModify()));
                  }
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("昵称"),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(user.user_name),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => NameModify(),
                    );
                  }
                ),
              ],
            ),
          ),

          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("性别"),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(user.user_sex),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  onTap: () async{
                    Pickers.showSinglePicker(context,
                      data: ['男', '女', '保密'],
                      selectData: sex,
                      onConfirm: (p, position) {
                        sex = p;
                        sexModify();
                      },
                      onChanged: (p, position) {;}
                    );
                  }
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("地区"),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(user.user_province + ((user.user_city == "未知" || user.user_city == "市辖区") ? "" : user.user_city) + (user.user_town == "未知" ? "" : user.user_town)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  onTap: () {
                    Pickers.showAddressPicker(
                      context,
                      initProvince: initProvince,
                      initCity: initCity,
                      initTown: initTown,
                      onConfirm: (p, c, t) {
                        initProvince = p;
                        if(c != null && c != "") initCity = c;
                        else initCity = "未知";
                        if(t != null && t != "") initTown = t;
                        else initTown = "未知";
                        areaModify();
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("等级"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text("Lv" + user.user_level.toString() + ",   " + user.user_exp.toString() + "/" + user.getExp().toString()),
                      ),
                    ],
                  ),
                  onTap: () async {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("学习次数"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(user.learn_times.toString()),
                      ),
                    ],
                  ),
                  onTap: () async {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("评测次数"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(user.eval_times.toString()),
                      ),
                    ],
                  ),
                  onTap: () async {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("分享次数"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(user.share_times.toString()),
                      ),
                    ],
                  ),
                  onTap: () async {}
                ),
              ],
            ),
          ),

          Card(
            elevation: 8,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("登录方式"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(user.getLoginWay()),
                      ),
                    ],
                  ),
                  onTap: () {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Text("登录账号"),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(user.getLoginNum()),
                      ),
                    ],
                  ),
                  onTap: () async {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Text("用户身份"),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(user.getLoginIdentity()),
                        ),
                      ],
                    ),
                    onTap: () async {}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Text("明星认证"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),

                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => StarVerify()));}
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Text("修改密码"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  onTap: ()
                  {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => PasswordModifyDialog(),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  Future<void> sexModify() async
  {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    if(sex == user.user_sex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("修改前后的性别相同！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      http.Response response = (await http.put(Uri.parse(UrlConstants.apiUrl+'//users/sex/${user.user_id}/${sex}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("修改成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
        user.user_sex = sex;
        UserInfoContainer.of(context)!.setUserInfo(user);
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("当前用户已注销！"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("请求错误: $e"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
    return ;
  }


  Future<void> areaModify() async
  {
    if(initCity == "全部" || initTown == "全部")
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("请选择市区！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    print(initCity);
    print(initTown);

    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    if(initProvince == user.user_province && initCity == user.user_city && initTown == user.user_town){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("修改前后的区域相同！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      http.Response response = (await http.put(Uri.parse(UrlConstants.apiUrl+'//users/area/${user.user_id}/${initProvince}/${initCity}/${initTown}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("修改成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
        user.user_province = initProvince;
        user.user_city = initCity;
        user.user_town = initTown;
        UserInfoContainer.of(context)!.setUserInfo(user);
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("当前用户已注销！"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("请求错误: $e"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
    return ;
  }
}