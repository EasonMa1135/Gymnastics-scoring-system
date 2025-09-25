import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

@JsonSerializable()
class TuitionInfo {
  BigInt tuition_id = BigInt.from(0);
  String tuition_name = "";
  String tuition_info = "";
  String tuition_pic = "";
  String tuition_video = "";
  int tuition_num = 0;
  String tuition_level = "";
  String tuition_duration = "";
  String dance_name = "";
  String recommend_url = "";
  int fee = 0;


  TuitionInfo({
    required this.tuition_id,
    required this.tuition_name,
    this.tuition_info = "",
    this.tuition_pic = "",
    this.tuition_video = "",
    this.tuition_num = 0,
    this.tuition_level = "",
    this.tuition_duration = "",
    this.dance_name = "",
    this.recommend_url = "",
    this.fee = 0,
  });

  TuitionInfo.fromMap(Map<String, dynamic> map)
  {
    this.tuition_id = BigInt.from(map['tuition_id']);
    this.tuition_name = map['tuition_name'];
    tuition_info = map['tuition_info']!=null?map['tuition_info']:"";
    tuition_pic = map['tuition_pic']!=null?map['tuition_pic']:"";
    tuition_video = map['tuition_video']!=null?map['tuition_video']:"";
    tuition_num = map['tuition_num']!=null?map['tuition_num']:0;
    tuition_level = map['tuition_level']!=null?map['tuition_level']:"";
    tuition_duration = map['tuition_duration']!=null?map['tuition_duration']:"";
    dance_name = map['dance_name']!=null?map['dance_name']:"";
    recommend_url = map['recommend_url']!=null?map['recommend_url']:"";
    fee = map['fee']!=null?map['fee']:0;
  }

  @override
  String toString() {
    return 'TuitionInfo{tuition_id: $tuition_id, tuition_name: $tuition_name, tuition_info: $tuition_info, tuition_pic: $tuition_pic, tuition_video: $tuition_video, tuition_num: $tuition_num, tuition_level: $tuition_level, tuition_duration: $tuition_duration, dance_name: $dance_name, recommend_url = $recommend_url, fee = $fee}';
  }

  static List<TuitionInfo> convert(List<Map<String, dynamic>> list)
  {
    return list.map((map) => TuitionInfo(
        tuition_id: BigInt.from(map['tuition_id']),
        tuition_name : map['tuition_name'],
        tuition_info : map['tuition_info']!=null?map['tuition_info']:"",
        tuition_pic : map['tuition_pic']!=null?map['tuition_pic']:"",
        tuition_video : map['tuition_video']!=null?map['tuition_video']:"",
        tuition_num : map['tuition_num']!=null?map['tuition_num']:0,
        tuition_level : map['tuition_level']!=null?map['tuition_level']:"",
        tuition_duration : map['tuition_duration']!=null?map['tuition_duration']:"",
        dance_name : map['dance_name']!=null?map['dance_name']:"",
        recommend_url : map['recommend_url']!=null?map['recommend_url']:"",
        fee : map['fee']!=null?map['fee']:0,
        )).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['tuition_id'] = this.tuition_id;
    map['tuition_name'] = this.tuition_name;
    map['tuition_info'] = this.tuition_info;
    map['tuition_pic'] = this.tuition_pic;
    map['tuition_video'] = this.tuition_video;
    map['tuition_num'] = this.tuition_num;
    map['tuition_level'] = this.tuition_level;
    map['tuition_duration'] = this.tuition_duration;
    map['dance_name'] = this.dance_name;
    map['recommend_url'] = this.recommend_url;
    map['fee'] = this.fee;
    return map;
  }

  // 重写 == 方法
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TuitionInfo &&
              runtimeType == other.runtimeType &&
              tuition_id == other.tuition_id;

  // 重写 hashCode 方法
  @override
  int get hashCode => tuition_id.hashCode;


}