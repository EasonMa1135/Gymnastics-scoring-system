import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../utils/resource_cos_upload.dart';
import '../../../../utils/user_info.dart';
import '../../../../utils/user_info_container.dart';
import '../../../../widgets/UploadImageWidget.dart';
import '../../../../widgets/snackbar.dart';

class TuitionAddPage extends StatefulWidget {
  static const String routeName = "/tuitionAdd-page";
  const TuitionAddPage({Key? key}) : super(key: key);

  @override
  _TuitionAddPageState createState() => _TuitionAddPageState();
}

class _TuitionAddPageState extends State<TuitionAddPage>
    with SingleTickerProviderStateMixin {
  File? image;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      CustomSnackBar(
          context,
          Row(children: [
            Icon(Icons.error),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text('未选定照片')
          ]),
          backgroundColor: Colors.red);
      return;
    }
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String object_key='recommend/tuition_id/$timestamp.png';
    String bucket_name='resource';
    String region='ap-nanjing';
    uploadImageToCOS(context,image!,object_key,bucket_name,region);
  }

  @override
  Widget build(BuildContext context) {
    UserInfo user = UserInfoContainer.of(context)!.widget.user;
    var PH = MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top;
    var PW = MediaQuery.of(context).size.width;

    final listView = Container(
        height:  PH * 0.9,
        width: PW * 0.9,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('增加教学'),
      ),
      body: Column(
        children: [
            UploadImageWidget(
              width: PW * 0.95,
              height: PH * 0.2 * 0.95,
              onImageSelected: (File imageFile) {
                // 处理图片上传逻辑
                print(imageFile.path);
                image=imageFile;
              },
          ),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            child:
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text("上传"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 设为圆角矩形
                ),
                minimumSize: Size(80, 40), // 最小宽高
                primary: Colors.blue, // 按钮主色，设为蓝色
                textStyle: TextStyle(fontSize: 15.0), // 文本样式
              ),
            ),
          ),
        ],
      ),
    );
  }
}
