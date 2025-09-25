import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/BackendSetting.dart';
import '../../utils/tuition_info.dart';
import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';
import 'package:video_player/video_player.dart';

import '../ScorePage/score_upload.dart';

class DetailPage extends StatefulWidget {
  final String params;
  static const String routeName = "/detail-page";
  const DetailPage({Key? key, required this.params}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late String tuition_id;
  TuitionInfo tuition = TuitionInfo(tuition_id: BigInt.from(0) ,tuition_name: '');

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isReady = false;

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;
  String mysqlText = '第一行\n第二行\n第三行';

  @override
  void dispose() {
    _pageController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tuition_id = widget.params;
    _fetchData();
    _pageController = PageController();
  }

  void initVideoPlayer(String url){
    // 创建视频控制器
    _controller = VideoPlayerController.network(url);
    // 异步初始化视频控制器
    _initializeVideoPlayerFuture = _controller.initialize();
    // 监听视频控制器的播放位置，更新播放进度条和时间显示
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // 执行一些操作
        _controller.seekTo(Duration.zero); // navigate to the beginning of the video after it ends
        _controller.pause(); // pause the video after it ends
        _isPlaying = false;
      }
      setState(() {
        _position = _controller.value.position;
        _duration = _controller.value.duration;
      });
    });
    _isReady = true;
  }

  Future<void> _fetchData() async {
    try {
      Response response = await Dio().get(UrlConstants.apiUrl + '/tuition/id/${BigInt.parse(tuition_id)}');
      if (response.statusCode == 200) {
        var body = response.data;
        Map<String, dynamic> map = Map<String, dynamic>.from(body['data']);
        tuition = TuitionInfo.fromMap(map);
        setState(() {  // 更新页面的状态
          initVideoPlayer(tuition.tuition_video);
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

    final player = Center(
      child: Container(
        height: PH * 0.4,
        width: PW * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, 3),
              blurRadius: 10.0,
            ),
          ],
          color: Colors.white,
        ),
        child:
        _isReady? FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                              _isPlaying = false;
                            } else {
                              _controller.play();
                              _isPlaying = true;
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: _VideoProgressIndicator(
                          controller: _controller,
                          duration: _duration,
                          position: _position,
                        ),
                      ),
                      Text(
                        '${_position.inHours}:${_position.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      ),
                      PopupMenuButton<double>(
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              child: Text('0.5x'),
                              value: 0.5,
                            ),
                            PopupMenuItem(
                              child: Text('1.0x'),
                              value: 1.0,
                            ),
                            PopupMenuItem(
                              child: Text('1.5x'),
                              value: 1.5,
                            ),
                            PopupMenuItem(
                              child: Text('2.0x'),
                              value: 2.0,
                            ),
                          ];
                        },
                        onSelected: (double speed) {
                          setState(() {
                            _playbackSpeed = speed;
                            _controller.setPlaybackSpeed(_playbackSpeed);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ):CircularProgressIndicator(),
      ),
    );

    final divider = Container(
      height: PH * 0.01,
      width: PW * 0.9,
      child: Divider(
        color: Colors.grey[500],
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
    );

    final info = Container(
      height: PH * 0.47,
      width: PW * 0.9,
      child: SingleChildScrollView(
            child: Column(
              children:[
                TitleComponent(titleText: tuition.tuition_name),
                divider,
                Row(
                  children: [
                    Icon(Icons.class_outlined),
                    Text(
                      textAlign: TextAlign.start,
                      ' 舞种：${tuition.dance_name}    ',
                      style: TextStyle(color: Colors.black87,fontSize: 16.0),
                    ),
                    Icon(Icons.play_arrow_outlined),
                    Text(
                      textAlign: TextAlign.start,
                      ' 学习人次：${tuition.tuition_num}',
                      style: TextStyle(color: Colors.black87,fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined),
                    Text(
                      textAlign: TextAlign.start,
                      ' 价格：${tuition.fee} 积分 ',
                      style: TextStyle(color: Colors.black87,fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: PH * 0.02),
                TitleComponent(titleText: "评分标准"),
                divider,
                Text.rich(
                    TextSpan(
                      children:
                      tuition.tuition_info.split('\n').map((line) {
                        return TextSpan(text: line + '\n');
                      }).toList(),
                    ),
                    style: TextStyle(color: Colors.black87, fontSize: 16.0)),
              ]
            ),
          ),
    );

    if (_isReady) {
      return Scaffold(
          appBar: AppBar(
            title: Text('教学详情'),
          ),
          body: Column(
            children: [
              SizedBox(height: PH * 0.02),
              player,
              SizedBox(height: PH * 0.02),
              info,
              SizedBox(height: PH * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                  child: Text("开始测评"),
                  // onPressed: () => ScoreUploadPage(),
                  onPressed: () => _navigateToScoreUploadPage(tuition.tuition_id.toString()),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 设为圆角矩形
                    ),
                    minimumSize: Size(100, 40), // 最小宽高
                    primary: Colors.blue, // 按钮主色，设为蓝色
                    textStyle: TextStyle(fontSize: 13.0), // 文本样式
                    ),
                  ),
                  SizedBox(width: PW * 0.05),
                  ElevatedButton(
                    child: Text("购买课程"),
                    // onPressed: () => ScoreUploadPage(),
                    onPressed: () => _navigateToScoreUploadPage(tuition.tuition_id.toString()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // 设为圆角矩形
                      ),
                      minimumSize: Size(100, 40), // 最小宽高
                      primary: Colors.blue, // 按钮主色，设为蓝色
                      textStyle: TextStyle(fontSize: 13.0), // 文本样式
                    ),
                  ),
                ],
              ),
            ],
          )
      );
    }else {
      // 显示加载中的消息
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  void _navigateToScoreUploadPage(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ScoreUploadPage(params: name),
        builder: (context) => ScoreUploadPage(),
      ),
    );
  }

}

class _VideoProgressIndicator extends StatelessWidget {
  const _VideoProgressIndicator({
    Key? key,
    required this.controller,
    required this.duration,
    required this.position,
  }) : super(key: key);

  final VideoPlayerController controller;
  final Duration duration;
  final Duration position;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: position.inMilliseconds.toDouble(),
      max: duration.inMilliseconds.toDouble(),
      onChanged: (value) {
        controller.seekTo(Duration(milliseconds: value.toInt()));
      },
    );
  }
}

class TitleComponent extends StatelessWidget {
  final String titleText;

  TitleComponent({required this.titleText});

  @override
  Widget build(BuildContext context) {
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;
    return SizedBox(
      height: PH * 0.05,
      width: PW * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          Text(
            titleText,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}