import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dance_scoring/utils/result_code.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../utils/BackendSetting.dart';
import 'package:path_provider/path_provider.dart';

class VerifyPage extends StatefulWidget {
  final Map<String, dynamic> verify;
  const VerifyPage({Key? key, required this.verify}) : super(key: key);
  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {

  String _imageFile_person = "";
  String _imageFile_emblem = "";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _imageFile_person = '${Assets.tempDir}/${widget.verify['file_person']}';
    _imageFile_emblem = '${Assets.tempDir}/${widget.verify['file_emblem']}';
    print(_imageFile_person);
    return Scaffold(
      appBar: AppBar(
        title: Text('明星认证'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('真实姓名:'),
              SizedBox(height: 5,),
              Text(widget.verify['verify_name']),
              SizedBox(height: 10,),
              Text('证件照人像面:'),
              SizedBox(height: 10,),
              Image.file(
                height: 160,
                width: 240,
                File(_imageFile_person),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10,),
              Text('证件照国徽面:'),
              SizedBox(height: 10,),
              Image.file(
                height: 160,
                width: 240,
                File(_imageFile_emblem),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  ElevatedButton(
                    onPressed: () async {
                      await verifyDeal(widget.verify['verify_id'].toSigned(64).toInt(), 2);
                    },
                    child: Text('拒绝'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80, 40),
                    ),
                  ),

                  SizedBox(width:30,),

                  ElevatedButton(
                    onPressed: () async {
                      await verifyDeal(widget.verify['verify_id'].toSigned(64).toInt(), 1);
                    },
                    child: Text('通过'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80, 40),
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyDeal(int verify_id, int choose) async //choose 1-通过 2-拒绝
  {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    try {
      http.Response response = (await http.put(Uri.parse(UrlConstants.apiUrl+'//users/verifyDeal/${user.user_id}/${verify_id}/${choose}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("处理成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      }
      else if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.VERIFY_DEALT))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("当前申请已被处理！"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
      else if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.VERIFY_NOT_FOUND))
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("当前申请不存在！"),
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
    Navigator.pop(context);
    return ;
  }
}