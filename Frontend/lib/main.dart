import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dance_scoring/pages/login_page.dart';
import 'package:dance_scoring/Pages/UserPage/user_page.dart';
import 'package:dance_scoring/Pages/HomePage/star_page.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/BackendSetting.dart';
import 'package:dance_scoring/utils/result_code.dart';
import 'package:dance_scoring/utils/get_data.dart';

import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /*

  */
  // 读取 shared preferences 中的 userData
  final prefs = await SharedPreferences.getInstance();
  final String? userData = prefs.getString('userData');
  // 检查是否需要自动登录
  late UserInfo user;
  if (userData != null) {

    final extractedUserData = decodeJson(userData) as Map<String, dynamic>;
    BigInt user_id = extractedUserData['user_id'];
    bool success = true;

    if (success) {
      user = await loginByUserId(user_id);
      // 自动登录成功，运行应用程序
    } else {
      user = await loginByUserId(BigInt.zero);
    }
  } else {
    user = await loginByUserId(BigInt.zero);
  }

  //设置缓存目录
  final tempDir = await getTemporaryDirectory(); // 获取应用程序缓存目录路径
  Assets.tempDir = tempDir.path;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final UserInfo user;
  MyApp({required this.user});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if(user.user_id == BigInt.zero) home = LoginPage();
    else home = UserPage();
    print("user_id: ${user.user_id}");
    if(user.user_avatar != "") downloadAvatarByUserId(user.user_id, user.user_avatar);
    return UserInfoContainer(
      user: user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '智慧舞蹈',
        home: home,
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          UserPage.routeName: (context) => UserPage(),
          StarPage.routeName: (context) => StarPage(),
        },
        //initialRoute: LoginPage.routeName,
      ),
    );
  }
}

Future<UserInfo> loginByUserId(BigInt user_id) async {
  if(user_id == BigInt.zero) return UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0));
  try {
    print(user_id);
    http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/loginById/${user_id}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
    String str = await response.body.toString();
    print("str: $str");

    final map = decodeJson(str) as Map<String, dynamic>;
    if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
    {
      UserInfo user = UserInfo.fromMap(map['data']);
      return user;
    }

    return UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0));
  } catch (e) {
    print(e);
    return UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0));
  }
}

