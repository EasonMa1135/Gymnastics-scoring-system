import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/result_code.dart';
import 'package:json_bigint/json_bigint.dart';
import '../../../utils/BackendSetting.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordModifyDialog extends StatefulWidget {
  @override
  _PasswordModifyDialogState createState() => _PasswordModifyDialogState();
}

class _PasswordModifyDialogState extends State<PasswordModifyDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _obscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: _obscureTextPassword,
              decoration: InputDecoration(
                labelText: '旧密码',
              ),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureTextPassword,
              decoration: InputDecoration(
                labelText: '新密码',
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _toggleLogin,
                  child: Icon(
                    _obscureTextPassword
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 15.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 30,),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('取消'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 设置文字颜色
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // 设置背景颜色
                  ),
                ),
                SizedBox(width: 20,),
                TextButton(
                  onPressed: () async {
                    passwordModify();
                    Navigator.pop(context);
                  },
                  child: Text('确认'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 设置文字颜色
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // 设置背景颜色
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> passwordModify() async
  {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;

    if(_newPasswordController.text == "" || _oldPasswordController.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("新旧密码不能为空！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if(_newPasswordController.text == _oldPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("新旧密码不能相同！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }

    var content_new = new Utf8Encoder().convert(_newPasswordController.text);
    String password_new = md5.convert(content_new).toString();

    var content_old = new Utf8Encoder().convert(_oldPasswordController.text);
    String password_old = md5.convert(content_old).toString();

    String password = user.user_password;

    if(password_old != password){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("旧密码错误！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      http.Response response = (await http.put(Uri.parse(UrlConstants.apiUrl+'//users/password/${user.user_id}/${password_new}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("修改成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));

        user.user_password = password_new;
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