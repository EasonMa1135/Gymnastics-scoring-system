import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/result_code.dart';
import 'package:json_bigint/json_bigint.dart';
import '../../../utils/BackendSetting.dart';

class NameModify extends StatefulWidget {
  const NameModify({Key? key}) : super(key: key);
  @override
  _NameModifyState createState() => _NameModifyState();
}

class _NameModifyState extends State<NameModify> {
  void initState() {
    super.initState();
  }
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _textController.text = UserInfoContainer.of(context)!.widget.user.user_name;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: '昵称',
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                    nameModify();
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> nameModify() async
  {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    String name = _textController.text;
    String name_old = user.user_name;

    if(name == null || name == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("昵称不能为空！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if(name == name_old){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("修改前后的昵称相同！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      return;
    }
    try {
      http.Response response = (await http.put(Uri.parse(UrlConstants.apiUrl+'//users/name/${user.user_id}/${name}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("修改成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));

        user.user_name = name;
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