import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/result_code.dart';
import 'package:dance_scoring/utils/BackendSetting.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<UserInfo> queryUserByID (BigInt user_id) async {

  //校验
  try {
    http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/show/${user_id}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
    String str = await response.body.toString();
    final map = decodeJson(str) as Map<String, dynamic>;

    if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
    {
      UserInfo user = UserInfo.fromMap(map['data']);
      if(user.user_avatar != "" )
      {
        downloadAvatarByUserId(user.user_id, user.user_avatar);
      }
      else {
        ;
      }
      return user;
    }
    else
    {
      Fluttertoast.showToast(
          msg: "此用户已注销！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "请求错误: $e",
        gravity: ToastGravity.CENTER,
        textColor: Colors.white);
  }
  return UserInfo(user_id: BigInt.from(0), user_telephone: "", user_password: "");
}

Future<void> downloadAvatarByUserId(BigInt user_id, String user_avatar) async
{
  try
  {
    http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/downloadAvatar/${user_id}')));
    final tempDir = await getTemporaryDirectory(); // 获取应用程序缓存目录路径
    Assets.tempDir = tempDir.path;
    final tempFile = File('${tempDir.path}/${user_avatar}'); // 在缓存目录中创建临时文件
    if (await tempFile.exists()) {
      //await tempFile.delete();
    }
    else
    {
      await tempFile.writeAsBytes(response.bodyBytes);
    }
  }catch (e) {
    print('请求错误: $e');
  }
  return;
}