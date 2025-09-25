import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tencent_cos_plus/tencent_cos_plus.dart';
import '../widgets/snackbar.dart';

// object_key:'recommend/tuition_id/timestamp.png'
// bucket_name:'resource'
// region:'ap-nanjing'
// return 资源访问地址
Future<String> uploadImageToCOS(BuildContext context,File _image,String object_key,String bucket_name,String region) async {
  if (_image == null) {
    CustomSnackBar(
        context,
        Row(children: [
          Icon(Icons.error),
          Padding(padding: EdgeInsets.only(left: 10)),
          Text('未选定文件')
        ]),
        backgroundColor: Colors.red);
    return "";
  }
  String appId = '1316978609';
  String secretId= 'AKIDNe5HOTYZSLBvU1WzHRTIvQlywhGis3tF';
  String secretKey= 'Ij4DTfex584oVFzaCya0DQTKzmRxFKF4';
  COSApiFactory.initialize(
    config: COSConfig(
      appId: appId,
      secretId: secretId,
      secretKey: secretKey,
    ),
    bucketName: bucket_name,
    region: region,
  );
  dynamic result;
  try {
    // 将本地的对象（Object）上传至指定存储桶中
    result = await COSApiFactory.objectApi.putObject(
      bucketName: bucket_name,
      region: region,
      objectKey: object_key,
      objectValue: _image?.readAsBytesSync(),
      contentType: 'image/png',
    );
    if (result.statusCode == 200) {
      CustomSnackBar(
          context,
          Row(children: [
            Icon(Icons.error),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text('上传完成')
          ]),
          backgroundColor: Colors.green);
      String url = "https://$bucket_name-$appId.cos.$region.myqcloud.com/$object_key";
      return url;
    } else {
      CustomSnackBar(
          context,
          Row(children: [
            Icon(Icons.error),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text('上传失败')
          ]),
          backgroundColor: Colors.red);
      print('Failed to delete data: ${result.statusCode}');
    }
  } catch (e) {
    CustomSnackBar(
        context,
        Row(children: [
          Icon(Icons.error),
          Padding(padding: EdgeInsets.only(left: 10)),
          Text('网络错误')
        ]),
        backgroundColor: Colors.red);
    print('Error loading data: $e');
  }
  return "";
}