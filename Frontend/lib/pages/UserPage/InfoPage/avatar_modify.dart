import 'package:flutter/material.dart';
import 'package:dance_scoring/theme.dart';
import 'package:json_bigint/json_bigint.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../utils/BackendSetting.dart';
import 'package:path_provider/path_provider.dart';

class AvatarModify extends StatefulWidget {
  const AvatarModify({Key? key}) : super(key: key);
  @override
  _AvatarModifyState createState() => _AvatarModifyState();
}

class _AvatarModifyState extends State<AvatarModify> {

  late String _imageFile;
  final ImagePicker _picker = ImagePicker();
  UserInfo user = UserInfo(user_telephone: "", user_password: "", user_id: BigInt.from(0));

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = UserInfoContainer.of(context)!.widget.user;
    _imageFile = '';


    return Scaffold(
      appBar: AppBar(
        title: Text('头像选择'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(backgroundImage: FileImage(File(Assets.avatarPath == "" ? Assets.assets_login_logo: Assets.avatarPath)), radius: 80),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    child: Text('拍照'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _getImageFromGallery,
                    child: Text('从相册选取'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///拍摄照片
  Future _getImageFromCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    // You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
    }
    await _picker.pickImage(source: ImageSource.camera)
        .then((image) => cropImage(image));
  }

  ///从相册选取
  Future _getImageFromGallery() async {
    await _picker.pickImage(source: ImageSource.gallery)
        .then((image) => cropImage(image));
  }

  Future<void> cropImage(XFile? originalImage) async {
    if (originalImage != null) {
      /*
      print(originalImage);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: originalImage,
        maxWidth: 256,
        maxHeight: 256,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle:'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            hideBottomControls: false,
            lockAspectRatio: true,
          ),

          IOSUiSettings(
            title: 'Cropper',
          ),

          WebUiSettings(
            context: context,
          ),
        ],
      );

      if(croppedFile == null)
      {
        return;
      }
      final fileName = croppedFile.path.split('/').last;
      final newFilePath = 'img/$fileName';
      */

      /*
      var status = await Permission.storage.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      }

      // You can can also directly ask the permission about its status.
      if (await Permission.location.isRestricted) {
        // The OS restricts access, for example because of parental controls.
      }
       */

      final newFilePath = user.user_id.toString() + "_" + originalImage.path.split('/').last;

      var bytes = null;
      try {
        bytes = await originalImage.readAsBytes();
      } catch (IOException) {
        Fluttertoast.showToast(
            msg: "图片读取失败！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
        return null;
      }
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(UrlConstants.apiUrl+'//users/avatar'),
        );
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: newFilePath,
          ),
        );
        request.fields['user_id'] = user.user_id.toString() ?? '0';
        request.fields['avatar'] = newFilePath;

        var response = await request.send();
        if (response.statusCode == 200) {
          if (true) {
            Fluttertoast.showToast(
                msg: "上传完成！",
                gravity: ToastGravity.CENTER,
                textColor: Colors.green);

            String str = await response.stream.bytesToString();
            final jsonResponse = decodeJson(str);
          }
        }

        final tempDir = await getTemporaryDirectory(); // 获取应用程序缓存目录路径
        Assets.tempDir = tempDir.path;
        final tempFile = File('${tempDir.path}/${newFilePath}'); // 在缓存目录中创建临时文件
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        await tempFile.writeAsBytes(bytes);
        Assets.avatarPath = tempFile.path;
        user.user_avatar = newFilePath;
        UserInfoContainer.of(context)!.setUserInfo(user);

      } catch (e) {
        Fluttertoast.showToast(
          msg: "上传失败！${e}",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      }
    } else {
      // 弹出一个错误信息
      Fluttertoast.showToast(
          msg: "请先选择有效文件！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
    }
    return null;
  }


}