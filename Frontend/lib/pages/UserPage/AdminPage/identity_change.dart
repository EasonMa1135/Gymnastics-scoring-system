import 'package:flutter/material.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:dio/dio.dart';
import 'package:dance_scoring/utils/result_code.dart';
import '../../../utils/BackendSetting.dart';

class IdentityChangePage extends StatefulWidget {
  const IdentityChangePage({Key? key}) : super(key: key);
  @override
  _IdentityChangePageState createState() => _IdentityChangePageState();
}

class _IdentityChangePageState extends State<IdentityChangePage> {
  final _textController = TextEditingController();
  final _nameController = TextEditingController();
  int? _selectedIdentity = 2;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('变更用户身份'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(labelText: '输入用户手机'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '输入认证名称（非明星不必输入）'),
          ),
          SizedBox(height: 20),
          Text('选择用户身份'),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                RadioListTile <int>(
                  title: const Text('学生'),
                  value: 2,
                  groupValue: _selectedIdentity,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedIdentity = value;
                    });
                  },
                ),
                RadioListTile <int>(
                  title: const Text('教师'),
                  value: 1,
                  groupValue: _selectedIdentity,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedIdentity = value;
                    });
                  },
                ),
                RadioListTile <int>(
                  title: const Text('管理员'),
                  value: 0,
                  groupValue: _selectedIdentity,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedIdentity = value;
                    });
                  },
                ),
                RadioListTile <int>(
                  title: const Text('明星'),
                  value: 3,
                  groupValue: _selectedIdentity,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedIdentity = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () {
            changeIdentity();
          },
          child: Text('确认'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> changeIdentity() async
  {
    String telephone = _textController.text;
    String tel_self = UserInfoContainer
        .of(context)!
        .widget
        .user
        .user_telephone;
    if (telephone == tel_self) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("您无法改变自己的身份！"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
    else {
      late Response response;
      final Dio _dio = Dio();

      if (_selectedIdentity as int <= 2)
      {
        try {
          response = await _dio.put(UrlConstants.apiUrl +
              '/users/identity/${telephone}/${_selectedIdentity}');
        } catch (e) {
          if (e is DioError) {
            if (e.response != null) {
              print('Error: ${e.response!.statusCode} ${e.response!
                  .statusMessage}');
            } else {
              print('Error connecting to the server');
            }
          } else {
            print('Unexpected error: $e');
          }
          return;
        }
      }
      else
      {
        String name = _nameController.text;
        try {
          response = await _dio.put(UrlConstants.apiUrl +
              '/users/identityStar/${telephone}/${name}');
        } catch (e) {
          if (e is DioError) {
            if (e.response != null) {
              print('Error: ${e.response!.statusCode} ${e.response!
                  .statusMessage}');
            } else {
              print('Error connecting to the server');
            }
          } else {
            print('Unexpected error: $e');
          }
          return;
        }
      }
      if (response.data['code'] == getResultCode(ResultCode.SUCCESS)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("修改成功！"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
      }
      else
      if (response.data['code'] == getResultCode(ResultCode.USER_NOT_FOUND)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("用户不存在！"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
      else
      if (response.data['code'] == getResultCode(ResultCode.IDENTITY_SAME)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("用户当前已是该身份！"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

}