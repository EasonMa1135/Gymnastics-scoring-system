import 'package:json_annotation/json_annotation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

@JsonSerializable()
class UserInfo {
  BigInt user_id = BigInt.from(0);
  int user_identity = 0;
  String user_name = "";
  String user_avatar = "";
  String user_telephone = "";
  String user_qq = "";
  String user_wechat = "";
  String user_password = "";
  String user_sex = "男";
  String user_province = "未知";
  String user_city = "";
  String user_town = "";
  int user_level = 1;
  int user_exp = 0;
  String verify_name = "";
  int learn_times = 0;
  int eval_times = 0;
  int share_times = 0;
  double wallet = 0.0;

  //user_identity 0-admin 1-teacher 2-student
  UserInfo({
    required this.user_telephone,
    required this.user_password,
    required this.user_id,
    this.user_identity = 0,
    this.user_name = "",
    this.user_avatar = "",
    this.user_qq = "",
    this.user_wechat = "",
    this.user_sex = "男",
    this.user_province = "未知",
    this.user_city = "",
    this.user_town = "",
    this.user_level = 1,
    this.user_exp = 0,
    this.verify_name = "",
    this.learn_times = 0,
    this.eval_times = 0,
    this.share_times = 0,
    this.wallet = 0.0,
  })
  {
    var content = new Utf8Encoder().convert(user_password);
    user_password = md5.convert(content).toString();
  }

  UserInfo.fromMap(Map<String, dynamic> map)
  {
    this.user_telephone = map['user_telephone'];
    this.user_password = map['user_password'];
    this.user_id = map['user_id'];
    this.user_identity = map['user_identity'].toSigned(64).toInt();
    this.user_name = map['user_name'];
    this.user_avatar = map['user_avatar'];
    this.user_qq = map['user_qq'];
    this.user_wechat = map['user_wechat'];
    this.user_sex = map['user_sex'];
    this.user_province = map['user_province'];
    this.user_city = map['user_city'];
    this.user_town = map['user_town'];
    this.user_level = map['user_level'].toSigned(64).toInt();
    this.user_exp = map['user_exp'].toSigned(64).toInt();
    this.verify_name = map['verify_name'];
    this.learn_times = map['learn_times'].toSigned(64).toInt();
    this.eval_times = map['eval_times'].toSigned(64).toInt();
    this.share_times = map['share_times'].toSigned(64).toInt();
    this.wallet = map['wallet'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['user_id'] = this.user_id;
    map['user_identity'] = this.user_identity;
    map['user_name'] = this.user_name;
    map['user_telephone'] = this.user_telephone;
    map['user_password'] = this.user_password;
    return map;
  }

  int getExp()
  {
    return 100 * this.user_level;
  }

  String getLoginWay()
  {
    if(this.user_telephone != "")
    {
      return "手机号登录";
    }
    else if(this.user_qq != "")
    {
      return "QQ登录";
    }
    else if(this.user_wechat != "")
    {
      return "微信登录";
    }
    return "";
  }

  String getLoginNum()
  {
    late String num;
    if(this.user_telephone != "")
    {
      num = this.user_telephone;
    }
    else if(this.user_qq != "")
    {
      num = this.user_qq;
    }
    else if(this.user_wechat != "")
    {
      num = this.user_wechat;
    }

    String prefix = num.substring(0, 1);
    String suffix = num.substring(num.length - 4);
    String mask = List.filled(num.length-5, '*').join();
    return "$prefix$mask$suffix";
  }

  String getLoginIdentity()
  {
    if(this.user_identity == 0)
    {
      return "管理员";
    }
    else if(this.user_identity == 1)
    {
      return "教师";
    }
    else if(this.user_identity == 2)
    {
      return "学生";
    }
    else if(this.user_identity == 3)  //待实现
    {
      return "明星用户";
    }
    return "";
  }
}