import 'package:dance_scoring/pages/ScorePage/score_result.dart';
import 'package:http/http.dart' as http;
import 'package:dance_scoring/pages/ScorePage/score_give.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/BackendSetting.dart';
import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';

class HistoryPage extends StatefulWidget {
  final int pageSize;

  HistoryPage({Key? key, this.pageSize = 6}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _page = 1;

  Future<List<dynamic>> get _evaluations async {
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'PageSize': widget.pageSize.toString(),
      'PageIndex': _page.toString(),
      'user_id': user!.user_id.toString(),
    });
    Response response = await dio
        .post(UrlConstants.apiUrl + '/evals/evalpageforuser', data: formData);
    print(response.data);
    return response.data as List<dynamic>;
  }

  void _showPage(int page) {
    setState(() {
      _page = page;
    });
  }

  Future<List> get _list async {
    print(UrlConstants.apiUrl +
        '/evals/evalNumforuser/' +
        user!.user_id.toString());
    final response = await http.get(Uri.parse(UrlConstants.apiUrl +
        '/evals/evalNumforuser/' +
        user!.user_id.toString()));
    int total = int.parse(response.body);
    int pageNum = total ~/ widget.pageSize + 1;
    return manageList(pageNum, _page);
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

  UserInfo? user;

  @override
  Widget build(BuildContext context) {
    user = UserInfoContainer.of(context)!.widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('个人评测历史'),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Card(
            child: FutureBuilder<List<dynamic>>(
              future: _evaluations, // Future 对象
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  final evaluations = snapshot.data!;
                  return Column(
                    children: evaluations
                        .map(
                          (eval) => SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    // 跳转到结果页面
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultPage(score: eval)));
                                  },
                                  title: Text('评测序号： ' +
                                      eval["eval_id"].toString() +
                                      ' '),
                                  subtitle: Text('上传时间： ' +
                                      eval["eval_time"]
                                          .toString()
                                          .substring(
                                              0,
                                              eval["eval_time"]
                                                      .toString()
                                                      .length -
                                                  10)
                                          .replaceAll('T', ' ')),
                                  // trailing: Text('算法评测分数： ' +
                                  //     ((eval["ai_total_score"] < 0)
                                  //         ? '未打分'
                                  //         : eval["ai_total_score"].toString()) +
                                  //     '  人工打分： ' +
                                  //     ((eval["manual_total_score"] < 0)
                                  //         ? '未打分'
                                  //         : eval["manual_total_score"]
                                  //             .toString())),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                                Divider(
                                  height: 0,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
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
}
