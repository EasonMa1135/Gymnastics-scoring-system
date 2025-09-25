import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dance_scoring/utils/BackendSetting.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/utils/get_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dance_scoring/pages/UserPage/InfoPage/show_page.dart';
import 'package:dance_scoring/utils/user_info.dart';

class SearchStarPage extends StatefulWidget {

  SearchStarPage({Key? key}) : super(key: key);

  @override
  _SearchStarPageState createState() => _SearchStarPageState();
}

class _SearchStarPageState extends State<SearchStarPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '请输入明星姓名',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),

        ),

        actions: [
          IconButton(
            onPressed: _handleSearch,
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _searchResults.isEmpty
          ? Center(child: Text('请输入搜索关键字'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (BuildContext context, int index) {
          final _user = _searchResults[index];
          return Column(
            children:
            [
              ListTile(
                onTap: () async {
                  UserInfo user = await queryUserByID(_user["user_id"]);
                  Navigator.push(context, MaterialPageRoute( builder: (context) => ShowPage(user: user)));
                },
                leading: CircleAvatar(
                backgroundImage: FileImage(File("${Assets.tempDir}/${_user["user_avatar"]}")),
                ), // <== 添加头像
                title: Text(_user["verify_name"].toString() + ' '),
                subtitle: Text('代表作： '),
                trailing: Icon(Icons.arrow_forward_ios),),
              Divider(
                height: 0,
              )
            ]
          );
        },
      ),
    );
  }

  void _handleSearch() async{
    final String keyword = _searchController.text;
    if (keyword.isNotEmpty) {
      try
      {
        final formData = {
          'name': keyword
        } as Map<String, dynamic>;
        final url = Uri.parse(UrlConstants.apiUrl+'//users/searchStar');
        var response = await http.post(url, body: formData, headers: {"Accept": "application/json; charset=utf-8"});
        String str = await response.body.toString();
        final map = decodeJson(str) as List<dynamic>;
        for (var item in map) {
          UserInfo user = UserInfo.fromMap(item);
          if(user.user_avatar != "" )
          {
            await downloadAvatarByUserId(user.user_id, user.user_avatar);
          }
        }
        setState(() {
          _searchResults = map;
        });
        return ;
      }catch (e) {
        Fluttertoast.showToast(
            msg: "获取失败！${e}",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
        return ;
      }
    }
  }
}