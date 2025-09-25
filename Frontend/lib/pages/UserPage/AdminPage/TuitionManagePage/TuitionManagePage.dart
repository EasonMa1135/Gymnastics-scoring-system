import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';
import 'package:dance_scoring/utils/tuition_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../utils/BackendSetting.dart';
import '../../../../utils/resource_cos_upload.dart';
import '../../../../utils/user_info.dart';
import '../../../../utils/user_info_container.dart';
import '../../../../widgets/UploadImageWidget.dart';
import '../../../../widgets/snackbar.dart';
import 'TuitionAddPage.dart';

class TuitionManagePage extends StatefulWidget {
  static const String routeName = "/tuitionManage-page";
  const TuitionManagePage({Key? key}) : super(key: key);

  @override
  _TuitionManagePageState createState() => _TuitionManagePageState();
}

class _TuitionManagePageState extends State<TuitionManagePage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  List<TuitionInfo> _items=[];
  List<TuitionInfo> _recommends=[];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchTuitionData();
    _fetchRecommendData();
  }

  Future<void> _fetchTuitionData() async {
    try {
      var dio = Dio();
      // 推荐位
      Response response = await dio.get(UrlConstants.apiUrl + '/tuition/DESC');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(body['data']);
          _items = TuitionInfo.convert(list);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
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
          _recommends = TuitionInfo.convert(list);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _addRecommend(TuitionInfo tuitionBean, String url) async {//添加推荐位
    //检查该课程是否已经在推荐中
    if(_recommends.contains(tuitionBean)){
      showResultDialog(context, "已在推荐列表");
      return;
    }
    var tuition ={
        "tuition_id":tuitionBean.tuition_id.toString(),
        "recommend_url":url
    };
    print(tuition["tuition_id"]);
    try {
      var dio = Dio();
      Response response = await dio.put(UrlConstants.apiUrl + '/tuition/addRecommend', data: tuition);
      if (response.statusCode == 200) {
        setState(() {  // 更新页面的状态
          _fetchRecommendData();
        });
        showResultDialog(context,'添加成功');
      } else {
        print('Failed to delete data: ${response.statusCode}');
        showResultDialog(context,'添加失败');
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
                  trailing: Container(
                    width: PW * 0.38,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          IconButton(
                            iconSize: 25,
                            icon: Icon(Icons.recommend),
                            color: Colors.blue,
                            onPressed: () {
                              // 按钮被按下时，执行此处代码
                              if(_recommends.contains(_items[index])){
                                showResultDialog(context, "已在推荐列表");
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  File? image;
                                  // 创建一个提示弹窗
                                  return AlertDialog(
                                    title: Text('请上传推荐位图片'),
                                    content:
                                        Container(
                                          width: PW,
                                          height: PH *0.2,
                                          child: UploadImageWidget(
                                            width: PW,
                                            height: PH *0.2,
                                            onImageSelected: (File imageFile) {
                                              // 处理图片上传逻辑
                                              image=imageFile;
                                            },
                                          ),
                                        ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text('取消'),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      ElevatedButton(
                                        child: Text('上传'),
                                        onPressed: () async {
                                          // 上传图片
                                          if (image == null) {
                                            CustomSnackBar(
                                                context,
                                                Row(children: [
                                                  Icon(Icons.error),
                                                  Padding(padding: EdgeInsets.only(left: 10)),
                                                  Text('未选定照片')
                                                ]),
                                                backgroundColor: Colors.red);
                                            return;
                                          }
                                          int timestamp = DateTime.now().millisecondsSinceEpoch;
                                          String object_key='recommend/${_items[index].tuition_id}/$timestamp.png';
                                          String bucket_name='resource';
                                          String region='ap-nanjing';
                                          // uploadImageToCOS(context,image!,object_key,bucket_name,region);
                                          String url = await uploadImageToCOS(context,image!,object_key,bucket_name,region);
                                          Navigator.of(context).pop(image); // 关闭对话框
                                          _addRecommend(_items[index],url);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
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
                                          // 这里添加点击删除后的代码
                                          // _deleteRecommend(_items[index]);
                                          Navigator.of(context).pop(); // 关闭对话框
                                        },
                                      ),
                                    ]
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            color: Colors.grey,
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
                                            // 这里添加点击删除后的代码
                                            // _deleteRecommend(_items[index]);
                                            Navigator.of(context).pop(); // 关闭对话框
                                          },
                                        ),
                                      ]
                                  );
                                },
                              );
                            },
                          ),
                        ]
                    ),
                  )
                ),
                  Divider()
                ],
            );
          },
        )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('课程管理'),
      ),
      body: Column(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TuitionAddPage()));
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
