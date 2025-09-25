import 'package:dance_scoring/pages/TuitionPage/tuition_detail.dart';
import 'package:dance_scoring/utils/tuition_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/BackendSetting.dart';
import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';

class ListPage extends StatefulWidget {
  final String params;
  static const String routeName = "/list-page";
  const ListPage({Key? key, required this.params}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late String dance_name;
  List<TuitionInfo> _tuition=[];

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 使用widget.params访问传入的参数
    dance_name = widget.params;
    _fetchDanceData();
    _pageController = PageController();
  }

  Future<void> _fetchDanceData() async {
    try {
      Response response = await Dio().get(UrlConstants.apiUrl + '/tuition/dance/${dance_name}/DESC');
      if (response.statusCode == 200) {
        var body = response.data;
        setState(() {  // 更新页面的状态
          List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(body['data']);
          // _tuition = List<TuitionInfo>.from(list);
          _tuition = TuitionInfo.convert(list);
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
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;

    final squareGrid = Container(
      height: PH * 0.6,
      width: PW * 0.9,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 2.5,
        children: List.generate(_tuition.length, (index) {
          return GestureDetector(
            onTap: () => _navigateToDetailsPage(_tuition[index].tuition_id.toString()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.accessibility),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  Text(
                    _tuition[index].tuition_name,
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

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

    return Scaffold(
      appBar: AppBar(
        title: Text('教学列表'),
      ),
      body: Column(
        children: [
          // title,
          SizedBox(height: PH * 0.02),
          Center(
            child: squareGrid,
          ),
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

}