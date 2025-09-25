import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';
import 'package:dance_scoring/utils/tuition_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../utils/BackendSetting.dart';
import '../../../../utils/user_info.dart';
import '../../../../utils/user_info_container.dart';
import 'TuitionManagePage.dart';

class RecommendManagePage extends StatefulWidget {
  static const String routeName = "/recommendManage-page";
  const RecommendManagePage({Key? key}) : super(key: key);

  @override
  _RecommendManagePageState createState() => _RecommendManagePageState();
}

class _RecommendManagePageState extends State<RecommendManagePage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  List<TuitionInfo> _items=[];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchRecommendData();
  }

  Future<void> _fetchRecommendData() async {//推荐位查询
    try {
      var dio = Dio();
      // 推荐位
      Response response = await dio.get(UrlConstants.apiUrl + '/tuition/recommend');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(body['data']);
          _items = TuitionInfo.convert(list);
          print(_items[0].tuition_id);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _deleteRecommend(TuitionInfo tuitionBean) async {//删除推荐位
    //检查当前推荐位数量，若推荐位<=1，不能删除
    if(_items.length <=1){
      showResultDialog(context, "删除失败，至少要有一条推荐");
      return;
    }
    try {
      var dio = Dio();
      var tuition={
        "tuition_id":tuitionBean.tuition_id.toString()
      };
      Response response = await dio.put(UrlConstants.apiUrl + '/tuition/deleteRecommend/',data: tuition);
      if (response.statusCode == 200) {
        setState(() {  // 更新页面的状态
          _fetchRecommendData();
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
        height:  PH * 0.88,
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
                      Text(_items[index].tuition_name),
                      SizedBox(height: 5,),
                      Text(
                        "ID:${_items[index].tuition_id.toString()}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ]
                ),
                onTap:() async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(params: _items[index].tuition_id.toString())));
                },
                trailing: ElevatedButton(
                  child: Text('删除'), // 按钮主色，设为蓝色
                  onPressed: () {
                    // 按钮被按下时，执行此处代码
                    // print('Button ${_items[index]['dance_name']} pressed.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // 创建一个提示弹窗
                        return AlertDialog(
                          title: Text('提示'),
                          content: Text('您是否确定要删除此内容？'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton(
                              child: Text('删除'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 关闭对话框
                                // 这里添加点击删除后的代码
                                _deleteRecommend(_items[index]);
                              },
                            ),
                          ],
                        );
                      },
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 设为圆角矩形
                    ),
                    primary: Colors.red, // 按钮主色，设为蓝色
                    textStyle: TextStyle(fontSize: 13.0), // 文本样式
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
        title: Text('推荐位管理'),
      ),
      body:Column(
        children: [
          Divider(),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TuitionManagePage()));
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