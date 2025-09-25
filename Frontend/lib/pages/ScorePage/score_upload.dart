import 'dart:convert';

import 'package:dance_scoring/pages/ScorePage/score_give.dart';
import 'package:dance_scoring/pages/ScorePage/score_result.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/BackendSetting.dart';
import '../../utils/user_info.dart';
import '../../utils/user_info_container.dart';
import '../../widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
class ScoreUploadPage extends StatefulWidget {
  const ScoreUploadPage({Key? key}) : super(key: key);

  @override
  _ScoreUploadPageState createState() => _ScoreUploadPageState();
}

class _ScoreUploadPageState extends State<ScoreUploadPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  XFile? sel_video = null;
  var TestState = ValueNotifier<String>('未选择视频');

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;
  var score = [-1,-1,-1,-1,-1,-1,-1,-1,-1];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    _pageController?.dispose();
    _controller?.dispose();
    _toBeDisposed?.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  late UserInfo user;

  @override
  Widget build(BuildContext context) {
    user = UserInfoContainer.of(context)!.widget.user;
    var PH = MediaQuery.of(context).size.height;
    var PW = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '舞蹈动作评测',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: PW - 30,
              child: Container(
                //container 居中
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: _previewVideo(),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            //我这里的card和上方的虚线边框不一样宽，请问怎样才能使其一样宽
            SizedBox(
              width: PW - 25,
              child: Card(
                child: Column(
                  //如何指定宽度
                  //
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      //文字居中

                      onTap: () async {
                        // 打开文件选择器
                        await VideoGet(context, this,false);
                        setState(() {});

                      },
                      title: Center(
                        child: Text(
                          '上传视频',
                        ),
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: Colors.grey[300],
                    ),
                    ListTile(
                        onTap: () async {
                          await VideoGet(context, this, true);
                          setState(() {});
                        },
                        title: Center(
                          child: Text(
                            '开始录像',
                          ),
                        )),
                    Visibility(
                      visible: user.user_identity <= 1,
                      child: Divider(
                        height: 0,
                        color: Colors.grey[300],
                      ),
                    ),

                    Visibility(
                      visible: user.user_identity <= 1,
                      child: ListTile(
                        onTap: () async {
                          if (this.sel_video == null) {
                            // 提示没选中文件
                          } else if (false) {
                            //提示没有权限
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GivePage(
                                          key: ValueKey('2'),
                                          ThisVideo: this.sel_video as XFile,
                                          eval_id: null,
                                        ))).then((value) => {
                                  print(value),
                                  if (value != null) this.score = value,
                                  setState(() {})
                                });

                            //跳转页面
                          }
                        },
                        title: Center(
                          child: Text(
                            '人工打分',
                          ),
                        ),
                      ),

                    ),
                    Divider(
                      height: 0,
                      color: Colors.grey[300],
                    ),
                    ListTile(
                      onTap: () async {
                        await _videoUpload(this, context);
                      },
                      title: Center(
                        child: Text(
                          '开始评测',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
                //水平居中

                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueListenableBuilder(
                  valueListenable: this.TestState,
                  builder: (ctx, String value, __) => Text(
                    '当前状态：' + value,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Future<http.Response?> _videoUpload(
      _ScoreUploadPageState handler, BuildContext context) async {
    // 如果用户选择了文件，上传它
    var video = handler.sel_video;
    if (video != null) {
      var bytes = null;
      try {
        bytes = await video.readAsBytes();
        this.TestState.value = '正在上传';
      } catch (IOException) {
        CustomSnackBar(
            context,
            Row(children: [
              Icon(Icons.error),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('文件读取失败')
            ]),
            backgroundColor: Colors.red);
        return null;
      }
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(UrlConstants.apiUrl+'//evals/file'),
        );
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'test.MP4',
          ),
        );
        request.fields['user_id'] = user.user_id.toString() ?? '0';
        request.fields['manual_score'] = this.score.join(',');

        var response = await request.send();
        this.TestState.value = '提示完成前请勿退出';
        if (response.statusCode == 200) {
          if (true) {
            CustomSnackBar(
                context,
                Row(children: [
                  Icon(Icons.error),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text('上传完成')
                ]),
                backgroundColor: Colors.green);
            this.TestState.value = '评测完成，请重新上传或退出';

            String str = await response.stream.bytesToString();
            final jsonResponse = json.decode(str);
            Map<String, dynamic> scoremap =
                jsonResponse as Map<String, dynamic>;

            // // 跳转到结果页面
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ResultPage(score: scoremap)));
          }
          return null;
          // TODO: 处理服务器的响应
        }
      } catch (e) {
        CustomSnackBar(
            context,
            Row(children: [
              Icon(Icons.error),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('上传失败')
            ]),
            backgroundColor: Colors.red);
        this.TestState.value = '上传失败';
        return null;
      }
    } else {
      // 弹出一个错误信息
      CustomSnackBar(
          context,
          Row(children: [
            Icon(Icons.error),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text('请先选择有效文件')
          ]),
          backgroundColor: Colors.red);
    }
    return null;
  }

  Future<void> VideoGet(
      BuildContext? context, _ScoreUploadPageState? handler, bool cam) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    XFile? file = await _picker.pickVideo(
        source: cam?ImageSource.camera:ImageSource.gallery, maxDuration: const Duration(seconds: 1000));
    // file = await compressVideo(file!);
    print(file);
    if (file != null) {
      this.sel_video = file;
      this.TestState.value = '文件已选中';
      print(file.path);
      await _playVideo(file);
    } else {
      print('未选中文件');
    }
  }

  // Future<XFile?> compressVideo(XFile videoFile) async {
  //   Directory tempDir;
  //   String tempPath;
  //
  //   if (!kIsWeb) {
  //     tempDir = await getTemporaryDirectory();
  //     tempPath = tempDir.path;
  //   } else {
  //     tempPath = path.basenameWithoutExtension(videoFile.path);
  //   }
  //
  //   var fileName = videoFile.path.split("/").last;
  //
  //   /// 决定 Web 和 Android 上的输出路径
  //   String outputPath = kIsWeb
  //       ? "$tempPath/${fileName}_compressed.mp4"
  //       : "$tempPath/$fileName";
  //
  //
  //   // 获取原始视频文件的码率
  //   int bitrate = await getVideoBitrate(videoFile.path);
  //
  //   // 设置压缩参数：码率为原始码率 80%
  //   int compressedBitrate = (bitrate * 0.8).round();
  //   List<String> command = [
  //     '-i',
  //     videoFile.path,
  //     '-s',
  //     '720x480',
  //     '-r',
  //     '30',
  //     '-b:v',
  //     '$compressedBitrate' + 'k', // 设置为原始码率 80%
  //     '-b:a',
  //     '64k',
  //     outputPath
  //   ];
  //
  //   // 小于100M不压缩
  //   int fileSize = await File(outputPath).length();
  //   if (fileSize < 100 * 1024 * 1024) {
  //     return videoFile;
  //   }
  //
  //   // 执行 FFmpeg 命令来压缩视频
  //   FlutterFFmpeg ffmpeg = FlutterFFmpeg();
  //   await ffmpeg.execute(command.join(' '));
  //
  //   // 如果输出视频文件大小超出了 100M，则递归调用 compressVideo 函数进行再次压缩
  //   fileSize = await File(outputPath).length();
  //   if (fileSize > 100 * 1024 * 1024) {
  //     return compressVideo(XFile(outputPath));
  //   }
  //
  //   // 封装压缩后的输出文件为 XFile 对象
  //   File compressedFile = File(outputPath);
  //   XFile compressedXFile = XFile(compressedFile.path);
  //   return compressedXFile;
  // }
  //
  // Future<int> getVideoBitrate(String videoPath) async {
  //   final List<String> arguments = [
  //     '-v',
  //     '0',
  //     '-select_streams',
  //     'v:0',
  //     '-show_entries',
  //     'stream=bit_rate',
  //     '-of',
  //     'default=noprint_wrappers=1:nokey=1',
  //     videoPath,
  //   ];
  //
  //   final FlutterFFmpeg ffmpeg = FlutterFFmpeg();
  //   final int bitrate = await ffmpeg.executeWithArguments(arguments);
  //
  //   return int.parse(bitrate.toString());
  // }

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path)
          ..initialize().then((value) => {_controller = controller,  setState(() {})});
        ;
      } else {
        controller = VideoPlayerController.file(File(file.path))
          ..initialize().then((value) => {_controller = controller, setState(() {})});
      }
      _controller = controller;
      const double volume = kIsWeb ? 0.0 : 1.0;
      await _controller?.setVolume(volume);
      await _controller?.setLooping(true);
    }
  }


  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    print('controller:' + _controller.toString());
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {super.key});

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;
  bool _isPlaying = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var PH = MediaQuery.of(context).size.height;
    var PW = MediaQuery.of(context).size.width;
    if (initialized) {
      return Center(
          child: Stack(children: [
        Center(
          child: SizedBox(
            width: 200 * controller!.value.aspectRatio,
            height: 200,
            child: VideoPlayer(controller!),
          ),
        ),
        GestureDetector(
            onTap: () {
              if (controller!.value.isPlaying) {
                controller!.pause();
                setState(() {
                  _isPlaying = false;
                });
              } else {
                controller!.play();
                setState(() {
                  _isPlaying = true;
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: !_isPlaying
                    ? Icon(Icons.stop_circle, size: 60.0, color: Colors.white)
                    : SizedBox.shrink(),
              ),
            ))
      ]));
    } else {
      return Container();
    }
  }

}
