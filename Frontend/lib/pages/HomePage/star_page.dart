import 'package:flutter/material.dart';
import 'package:dance_scoring/utils/get_data.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/pages/UserPage/InfoPage/show_page.dart';
import 'package:dance_scoring/pages/HomePage/StarPage/whole_star.dart';
import 'package:dance_scoring/pages/HomePage/StarPage/area_star.dart';
import 'package:dance_scoring/pages/HomePage/StarPage/student_star.dart';
import 'package:dance_scoring/pages/HomePage/StarPage/search_star.dart';
import 'package:dance_scoring/utils/infos.dart';
import '../../../utils/BackendSetting.dart';
import 'dart:io';
class StarPage extends StatefulWidget {
  const StarPage({Key? key}) : super(key: key);
  static const String routeName = "/明星";


  @override
  _StarPageState createState() => _StarPageState();
}

class Ad {
  final String imageUrl;
  final String text;

  Ad({required this.imageUrl, required this.text});
}

class _StarPageState extends State<StarPage> {
  void initState() {
    super.initState();
  }

  final List<Ad> _ads = [
    Ad(
        imageUrl:
        'https://picsum.photos/id/237/300/200',
        text: '这是第一条广告'),
    Ad(
        imageUrl:
        'https://picsum.photos/id/238/300/200',
        text: '这是第二条广告'),
    Ad(
        imageUrl:
        'https://picsum.photos/id/239/300/200',
        text: '这是第三条广告'),
  ];
  List<Widget> starList = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < starRecommend.recommendID.length; i++) {
      starList.add(_buildStar(context, starRecommend.recommendID[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('明星加盟'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            height: 280.0,
            child: PageView.builder(
              itemCount: _ads.length,
              itemBuilder: (context, index) {
                final ad = _ads[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 190, // 设置FittedBox高度
                        child: FittedBox(
                          child: Image.network(ad.imageUrl),
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(ad.text),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 220,
            child: GridTile(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    children: [
                      ...starList
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildButton(context, "更多明星", () => _handleMoreStar(context)),
                _buildButton(context, "地区明星", () => _handleAreaStar(context)),
                _buildButton(context, "测评明星", () => _handleStudentStar(context)),
                _buildButton(context, "搜索明星", () => _handleSearchStar(context)),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, void Function() onTap) {
    return Container(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.lightBlue[100],
        ),
        onPressed: onTap,
        child: Text(label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildStar(BuildContext context, BigInt id) {
    return FutureBuilder(
      future: fetchData(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              _handleStarTap(context, data['user']); // Call a method when the user taps on the widget
            },
            child: Container(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: FileImage(File(data['avatar'])),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(data['name'])
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error retrieving data');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<Map<String, dynamic>> fetchData(BigInt id) async {
    if(id != BigInt.zero)
    {
      UserInfo userQuery = await queryUserByID(id);
      return {
        'name': userQuery.verify_name,
        'avatar': "${Assets.tempDir}/${userQuery.user_avatar}",
        'user': userQuery,
      };
    }
    else
    return {
      'name': "",
      'avatar': "",
      'user': UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0))
    };
  }

  void _handleStarTap(BuildContext context, UserInfo user) {
    // Implement the method that should be executed when a user taps on the star widget
    // For example, you can navigate to another screen that shows the details of the star
    Navigator.push(context, MaterialPageRoute( builder: (context) => ShowPage(user: user)));
  }

  void _handleMoreStar(BuildContext context) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => WholeStarPage()));
  }

  void _handleAreaStar(BuildContext context) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => AreaStarPage()));
  }

  void _handleStudentStar(BuildContext context) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => StudentStarPage()));
  }

  void _handleSearchStar(BuildContext context) {
    Navigator.push(context, MaterialPageRoute( builder: (context) => SearchStarPage()));
  }
}