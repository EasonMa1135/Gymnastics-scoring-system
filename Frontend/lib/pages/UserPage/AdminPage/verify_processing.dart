import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dance_scoring/pages/UserPage/AdminPage/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:dance_scoring/utils/BackendSetting.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class VerifyProcessing extends StatefulWidget {
  final int pageSize;

  VerifyProcessing({Key? key, this.pageSize = 7}) : super(key: key);

  @override
  _VerifyProcessingState createState() => _VerifyProcessingState();
}

class _VerifyProcessingState extends State<VerifyProcessing> {
  int _page = 1;

  Future<List<dynamic>> get _verifiers async {
    try
    {
      final formData = {
        'PageSize': widget.pageSize.toString(),
        'PageIndex': _page.toString()
      } as Map<String, dynamic>;
      final url = Uri.parse(UrlConstants.apiUrl+'//users/getVerifyPage');
      var response = await http.post(url, body: formData, headers: {"Accept": "application/json; charset=utf-8"});
      String str = await response.body.toString();
      final map = decodeJson(str) as List<dynamic>;
      return map;
    }catch (e) {
      Fluttertoast.showToast(
          msg: "获取认证申请失败！${e}",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      return <dynamic>[];
    }
  }

  void _showPage(int page) {
    setState(() {
      _page = page;
    });
  }

  Future<List> get _list async {
    try
    {
      http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/getVerifyNum'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      int total = int.parse(str);
      int pageNum = total ~/ widget.pageSize + 1;
      return manageList(pageNum, _page);
    }catch (e) {
      Fluttertoast.showToast(
      msg: "获取列表失败！${e}",
      gravity: ToastGravity.CENTER,
      textColor: Colors.red);
      return <dynamic>[];
    }
  }

  List manageList(int _pageCount, int _page) {
    List _list = [];
    if (_pageCount <= 1) {
      return [];
    }
    if (_pageCount <= 7) {
      for (var i = 0; i < _pageCount; i++) {
        _list.add(i + 1);
      }
    } else if (_page <= 4) {
      _list = [1, 2, 3, 4, 5, -2, _pageCount];
    } else if (_page > _pageCount - 3) {
      _list = [
        1,
        2,
        -2,
        _pageCount - 3,
        _pageCount - 2,
        _pageCount - 1,
        _pageCount
      ];
    } else {
      _list = [1, -2, _page - 1, _page, _page + 1, -2, _pageCount];
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('明星认证处理'),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Card(
            child: FutureBuilder<List<dynamic>>(
              future: _verifiers, // Future 对象
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  final verifiers = snapshot.data!;
                  return Column(
                    children: verifiers.map((verify) => SizedBox(
                      width: double.infinity,
                      // height: 80,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              await downloadImgByVerifyID(verify);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyPage(
                                    verify: verify,
                                  )));
                              setState(() {});
                            },
                            title: Text('申请用户ID：' + verify["user_id"].toString() + ' '),
                            subtitle: Text('认证姓名： ' + verify["verify_name"].toString()),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          Divider(
                            height: 0,
                          )
                        ],
                      ),),
                    ).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('发生错误: ${snapshot.error}');
                } else {
                  // 未完成
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
      bottomSheet: Card(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: FutureBuilder<List>(
            future: _list,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  list.map((index) => _buildNavButton(index)).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // 默认显示一个进度指示器
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  // 辅助函数：创建按钮
  Widget _buildNavButton(int page) {
    if (page == -2) {
      return ElevatedButton(
        onPressed: () => _showPage(_page),
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // 设置按钮背景颜色
          minimumSize: Size(MediaQuery.of(context).size.width / 8.0, 30.0),
        ),
        child: Text(
          '...',
          style: TextStyle(
            color: Colors.black, // 设置按钮文本颜色
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () => _showPage(page),
        style: ElevatedButton.styleFrom(
          primary: _page == page ? Colors.blue : Colors.white, // 设置按钮背景颜色
          minimumSize: Size(MediaQuery.of(context).size.width / 8.0, 30.0),
        ),
        child: Text(
          '${page}',
          style: TextStyle(
            color: _page == page ? Colors.white : Colors.black, // 设置按钮文本颜色
          ),
        ),
      );
    }
  }

  Future<void> downloadImgByVerifyID(Map<String, dynamic> verify) async
  {
    try
    {
      http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/downloadVerify/${verify['verify_id'].toString()}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      final bytesList = (json.decode(utf8.decode(response.bodyBytes)) as List).map((e) => (e as List).map((e) => e as int).toList()).toList();
      final fileBytes_person = bytesList[0];
      final fileBytes_emblem = bytesList[1];
      final file_person = await File('${Assets.tempDir}/${verify['file_person']}').writeAsBytes(fileBytes_person);
      final file_emblem = await File('${Assets.tempDir}/${verify['file_emblem']}').writeAsBytes(fileBytes_emblem);
      print(file_person.path);

    }catch (e) {
      print('请求错误: $e');
    }

    return;
  }
}