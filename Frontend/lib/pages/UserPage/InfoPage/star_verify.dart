import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dance_scoring/utils/result_code.dart';
import 'dart:io';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../utils/BackendSetting.dart';
import 'package:path_provider/path_provider.dart';

class StarVerify extends StatefulWidget {
  const StarVerify({Key? key}) : super(key: key);
  @override
  _StarVerifyState createState() => _StarVerifyState();
}

class _StarVerifyState extends State<StarVerify> {

  String _imageFile_person = '';
  String _imageFile_emblem = '';
  final ImagePicker _picker = ImagePicker();
  final _textController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //user = UserInfoContainer.of(context)!.widget.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('明星认证'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: '真实姓名',
                ),
              ),
              SizedBox(height: 10,),
              Text('证件照人像面:'),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('从相册选择'),
                            onTap: () async{
                              Navigator.pop(context);
                              await _getImageFromGallery(true);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('拍照'),
                            onTap: () async{
                              Navigator.pop(context);
                              await _getImageFromCamera(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child:
                  _imageFile_person == '' ?
                  Container(
                    height: 160,
                    width: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.grey[400],
                    )
                  ):
                  Image.file(
                    height: 160,
                    width: 240,
                    File(_imageFile_person),
                    fit: BoxFit.cover,
                  ),
              ),
              SizedBox(height: 10,),
              Text('证件照国徽面:'),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.photo_library),
                            title: Text('从相册选择'),
                            onTap: () async{
                              Navigator.pop(context);
                              await _getImageFromGallery(false);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('拍照'),
                            onTap: () async{
                              Navigator.pop(context);
                              await _getImageFromCamera(false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child:
                  _imageFile_emblem == '' ?
                  Container(
                    height: 160,
                    width: 240,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.grey[400],
                    ),
                  ):
                  Image.file(
                    height: 160,
                    width: 240,
                    File(_imageFile_emblem),
                    fit: BoxFit.cover,
                  ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await _verify(); },
                    child: Text('认证申请'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  ///拍摄照片
  Future<void> _getImageFromCamera(bool person) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }
    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
    await _picker.pickImage(source: ImageSource.camera)
        .then((image) => saveImage(image, person));
    return;
  }

  ///从相册选取
  Future<void> _getImageFromGallery(bool person) async {
    await _picker.pickImage(source: ImageSource.gallery)
        .then((image) => saveImage(image, person));
    return;
  }

  Future<void> saveImage(XFile? originalImage, bool person) async {
    if (originalImage != null) {
      setState((){
        if(person) _imageFile_person = originalImage?.path as String;
        else _imageFile_emblem = originalImage?.path as String;
      });
    } else {
      // 弹出一个错误信息
      Fluttertoast.showToast(
          msg: "请先选择有效文件！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
    }
    return null;
  }

  Future<void> _verify() async
  {
    if(_textController.text == "")
    {
      Fluttertoast.showToast(
          msg: "请先输入姓名！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      return;
    }
    if(_imageFile_person == "" || _imageFile_emblem == "")
    {
      Fluttertoast.showToast(
          msg: "请先上传身份证图片！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      return;
    }
    var bytes_person = null, bytes_emblem = null;
    try {
      bytes_person = await File(_imageFile_person).readAsBytes();
      bytes_emblem = await File(_imageFile_emblem).readAsBytes();
    } catch (IOException) {
      Fluttertoast.showToast(
          msg: "图片读取失败！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      return null;
    }
    try {
      String id = UserInfoContainer.of(context)!.widget.user.user_id.toString();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(UrlConstants.apiUrl + '//users/verify'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_person',
          bytes_person,
          filename: id + "_verify_person.png",
        ),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'file_emblem',
          bytes_emblem,
          filename: id + "_verify_emblem.png",
        ),
      );
      request.fields['user_id'] = id;
      request.fields['verify_name'] = _textController.text;
      var response = await request.send();
      var responseString = await response.stream.transform(utf8.decoder).join();
      final map = decodeJson(responseString) as Map<String, dynamic>;
      if (map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS)) {
        Fluttertoast.showToast(
            msg: "申请完成，请耐心等待管理员处理！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.green);
        Navigator.pop(context);
      }
      else if (map['code'].toSigned(64).toInt() == getResultCode(ResultCode.VERIFY_EXISTED))
      {
        Fluttertoast.showToast(
            msg: "请勿重复申请！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
        Navigator.pop(context);
      }
    }catch (e) {
      Fluttertoast.showToast(
          msg: "申请失败！${e}",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
    }
    return;
  }
}