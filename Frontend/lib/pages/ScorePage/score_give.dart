import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/BackendSetting.dart';

/// Stateful widget to fetch and then display video content.
class GivePage extends StatefulWidget {
  final int? eval_id;
  final XFile? ThisVideo;
  const GivePage({Key? key, required this.ThisVideo, required this.eval_id})
      : super(key: key);

  @override
  _GivePageState createState() => _GivePageState();
}

class _GivePageState extends State<GivePage> {
  late VideoPlayerController _controller;
  bool _isplaying = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  ///用于监听播放器状
  @override
  void initState() {
    if (widget.eval_id == null && widget.ThisVideo != null) {
      super.initState();
      print('playing+ ${widget.ThisVideo?.path}');
      if (kIsWeb)
        _controller =
            VideoPlayerController.network(widget.ThisVideo?.path as String)
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
      else
        _controller =
            VideoPlayerController.file(File(widget.ThisVideo?.path as String))
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {});
              });
      _controller.setLooping(true);
      _isplaying = true;
    } else {
      super.initState();
      getVideofromWeb();
    }
  }

  Future<void> getVideofromWeb() async {
    final response = await http.get(Uri.parse(UrlConstants.apiUrl +
        '/evals/downloadFile/' +
        widget.eval_id.toString()));
    final tempDir = await getTemporaryDirectory(); // 获取应用程序缓存目录路径
    final tempFile = File('${tempDir.path}/video.mp4'); // 在缓存目录中创建临时文件
    await tempFile.writeAsBytes(response.bodyBytes); // 将响应体写入临时文件
    setState(() {
      _controller = VideoPlayerController.file(tempFile)
        ..initialize().then((_) {
          setState(() {
            _isplaying = true;
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          // 设置AppBar的标题
          title: Text('评分'),
          // 添加返回按钮
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: _isplaying && _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                if (_isplaying) {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                }
              },
              child: Icon(
                _isplaying && _controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
            SizedBox(
              width: 20,
            ), // Add this SizedBox widget to provide space between the two buttons
            FloatingActionButton(
              heroTag: 'other',
              onPressed: () {
                // Add your onPressed function here for the second button
                give_Score();
              },
              child: Text('评分'),
            ),
          ],
        ),
      ),
    );
  }

  String? check_Score(String? value) {
    if (value?.isEmpty ?? true) {
      return null;
    } else if (!RegExp(r'^\d{1,3}$').hasMatch(value!)) {
      return '分数必须是0-100的整数';
    } else if (int.parse(value!) < 0 || int.parse(value) > 100) {
      return '分数必须是0-100的整数';
    }
    return null;
  }

  void give_Score() {
    var _score = [-1, -1, -1, -1, -1, -1, -1, -1, -1];
    var titles = ['整体', '头颈', '左臂', '右臂', '胸腹', '腰胯', '左腿', '右腿', '节奏'];
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rate this video"),
            content: SizedBox(
                width: 150,
                child: Form(
                    key: _formKey,
                    child: SizedBox(
                        width: 150,
                        child: ListView.builder(
                          itemCount: 9,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                                width: 150,
                                child: Row(children: [
                                  SizedBox(
                                      width: 150,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "请输入分数-${titles[index]}",
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: check_Score,
                                        onSaved: (value) {
                                          if (value != '')
                                            _score[index] = int.parse(value!);
                                        },
                                      )),
                                ]));
                          },
                        )))),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  } else
                    return;
                  print(_score);
                  // Add your code here for when the user taps OK
                  Navigator.of(context).pop();
                  //要往后端更新分数
                  if (widget.eval_id != null) {
                    //更新分数
                    var dio = Dio();
                    FormData formData = FormData.fromMap({
                      'eval_id': widget.eval_id.toString(),
                      'score': _score,
                    });
                    dio.post(UrlConstants.apiUrl + '/evals/manual_score',
                        data: formData);
                  }
                  if (widget.eval_id == null) Navigator.of(context).pop(_score);
                },
              ),
            ],
          );
        });
  }
}

//视频缓冲过程中显示这个页面，可以加个loading效果
class PlayerHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
