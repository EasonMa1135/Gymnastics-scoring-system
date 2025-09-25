import 'dart:convert';

import 'package:dance_scoring/pages/TuitionPage/tuition_list.dart';
import 'package:dance_scoring/pages/UserPage/AdminPage/tuition_setting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/BackendSetting.dart';
import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';

class RecommendPage extends StatefulWidget {
  static const String routeName = "/recommend-page";
  const RecommendPage({Key? key}) : super(key: key);

  @override
  _RecommandPageState createState() => _RecommandPageState();
}

class _RecommandPageState extends State<RecommendPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  // List<Map<String,String>> _images = [
  // {'url':"https://picsum.photos/id/1018/300/200","tuition_id":"1099716930891153408"},
  // {'url':"https://picsum.photos/id/1018/300/200","tuition_id":"1099716930891153408"},
  // ];
  List<Map<String, dynamic>> _images=[];
  List<Map<String, dynamic>> _dance=[];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDanceData();
    _pageController = PageController();
  }

  Future<void> _fetchDanceData() async {
    try {
      var dio = Dio();
      // 舞蹈类别
      Response response = await dio.get(UrlConstants.apiUrl + '/dance');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          _dance = List<Map<String, dynamic>>.from(body['data']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
      // 推荐位
      response = await dio.get(UrlConstants.apiUrl + '/tuition/recommend');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          _images = List<Map<String, dynamic>>.from(body['data']);
          print(_images[0]['tuition_id']);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    // var PH = MediaQuery.of(context).size.height;
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;
    // 推荐位轮播图
    final carousel = Container(
      height: PH * 0.2,
      width: PW,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: _images.map(
              (item) => GestureDetector(
            onTap: () => _navigateToDetailsPage(item['tuition_id'].toString()),
            child: Container(
              child: Center(
                child: Image.network(
                  item['recommend_url'],
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ).toList(),
      ),
    );

    //分隔标题
    final title = SizedBox(
      height: PH * 0.025,
      width: PW * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.start),
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          Text('舞蹈分类',
              style: TextStyle(fontSize: 15.0),
          ),
        ],
      ),
    );

    //舞蹈分类N宫格
    final squareGrid = Container(
      height:  PH * 0.6,
      width: PW * 0.9,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 2.5,
        children: List.generate(_dance.length, (index) {
          return GestureDetector(
            onTap: () => _navigateToListPage(_dance[index]['dance_name']),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                    Text(
                    _dance[index]['dance_name'],
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

    //布局，放置排列组件
    return Scaffold(
      body: Column(
        children: [
          (_images.isEmpty)?CircularProgressIndicator():carousel,
          SizedBox(height: PH * 0.01),
          title,
          SizedBox(height: PH * 0.02),
          (_dance.isEmpty)?CircularProgressIndicator():squareGrid,
          SizedBox(height: PH * 0.005),
        ],
      ),
    );
  }

  void _navigateToDetailsPage(String tuition_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(params: tuition_id),
      ),
    );
  }

  void _navigateToListPage(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(params: name),
      ),
    );
  }

}