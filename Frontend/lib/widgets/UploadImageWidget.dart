import 'dart:io';
import 'package:dance_scoring/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_cos_plus/tencent_cos_plus.dart';
import '../utils/BackendSetting.dart';
import '../utils/resource_cos_upload.dart';


// 该组件实现移动端本地上传相册照片，并返回照片的url
class UploadImageWidget extends StatefulWidget {
  final Function(File) onImageSelected;
  final double height;
  final double width;
  UploadImageWidget({Key? key, required this.onImageSelected, required this.height, required this.width}) : super(key: key);

  @override
  _UploadImageWidgetState createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              onTap: () {
                _pickImage();
              },
              child:Container(
              alignment: Alignment.center,
              child:
                Container(
                  height: widget.height,
                  width: widget.width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Text("点击此处上传图片")
                      : Image.file(
                    _image!,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}