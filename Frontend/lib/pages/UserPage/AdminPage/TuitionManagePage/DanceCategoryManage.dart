import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';
import 'package:dance_scoring/utils/tuition_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../utils/BackendSetting.dart';
import '../../../../utils/user_info.dart';
import '../../../../utils/user_info_container.dart';

class DanceManagePage extends StatefulWidget {
  static const String routeName = "/danceManage-page";
  const DanceManagePage({Key? key}) : super(key: key);

  @override
  _DanceManagePageState createState() => _DanceManagePageState();
}

class _DanceManagePageState extends State<DanceManagePage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  List<Map<String, dynamic>> _items=[];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDanceData();
  }

  Future<void> _fetchDanceData() async {
    try {
      var dio = Dio();
      // 舞蹈类别
      Response response = await dio.get(UrlConstants.apiUrl + '/dance');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          _items = List<Map<String, dynamic>>.from(body['data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _deleteDance(String dance_name) async {
    try {
      var dio = Dio();
      // 舞蹈类别
      print(dance_name);

      Response response = await dio.delete(UrlConstants.apiUrl + '/dance/name/${dance_name}');
      if (response.statusCode == 200) {
        setState(() {  // 更新页面的状态
          _fetchDanceData();
        });
        showResultDialog(context,'删除成功');
      } else {
        print('Failed to delete data: ${response.statusCode}');
        showResultDialog(context,'删除失败');
      }
    } catch (e) {
      print('Error loading data: $e');
      showResultDialog(context,'网络错误');
    }
  }

  Future<void> _addDance(String dance_name,String dance_info) async {
    try {
      var dio = Dio();
      // 舞蹈类别
      if(dance_name == null || dance_name == ""){
        return ;
      }
      var danceBean ={
        "dance_name":dance_name,
        "dance_info":dance_info
      };
      Response response = await dio.post(UrlConstants.apiUrl + '/dance',data: danceBean);
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          _fetchDanceData();
        });
        showResultDialog(context,body['message']);
      } else {
        print('Failed to add data: ${response.statusCode}');
        showResultDialog(context,response.statusMessage.toString());
      }
    } catch (e) {
      print('Error loading data: $e');
      showResultDialog(context,'网络错误');
    }
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(result),
          actions: <Widget>[
            ElevatedButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭弹窗
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;

    final listView = Container(
        height: PH * 0.9,
        width: PW * 0.9,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text(_items[index]['dance_name']),
                    SizedBox(height: 5,),
                    Text(
                      "ID:${_items[index]['dance_id']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        ),
                      ),
                    ]
                  ),
                  trailing: ElevatedButton(
                    child: Text('删除'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('提示'),
                            content: Text('您是否确定要删除此内容？相关分类下的教学也将被删去。'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('取消'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child: Text('删除'),
                                onPressed: () {
                                  _deleteDance(_items[index]['dance_name']);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Colors.red,
                      textStyle: TextStyle(fontSize: 13.0),
                    ),
                  ),
                ),
                Divider()
              ],
            );
          },
        )
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('分类管理'),
      ),
      body: Column(
        children: [
            Center(
              child: listView,
            ),
            Center(
              child: Container(
              // width: PH * 0.08,
              // height: PH * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  // 按钮被按下时，执行此处代码
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // 首先定义两个FocusNode以便在点击弹窗中的提交按钮时隐藏键盘
                      final nameFocusNode = FocusNode();
                      final infoFocusNode = FocusNode();
                      String dance_name = '';
                      String dance_info = '';
                      // 创建一个提示弹窗
                      return AlertDialog(
                        title: Text('添加分类'),
                        content:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                            TextField(
                              autofocus: true,
                              focusNode: nameFocusNode,
                              decoration: InputDecoration(hintText: '请输入分类名称'),
                              onChanged: (value) {
                                dance_name = value;
                              },
                              onSubmitted: (value) {
                                FocusScope.of(context).requestFocus(infoFocusNode);
                              },
                            ),
                            TextField(
                              focusNode: infoFocusNode,
                              decoration: InputDecoration(hintText: '请输入分类简介'),
                              onChanged: (value) {
                                dance_info = value;
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text('取消'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          ElevatedButton(
                            child: Text('添加'),
                            onPressed: () {
                              nameFocusNode.unfocus();
                              infoFocusNode.unfocus();
                              print('分类：$dance_name');
                              print('简介：$dance_info');
                              _addDance(dance_name,dance_info);
                              Navigator.of(context).pop(); // 关闭对话框
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
