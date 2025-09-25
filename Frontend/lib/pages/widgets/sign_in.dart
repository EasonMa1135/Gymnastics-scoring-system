import 'dart:convert';
import 'package:json_bigint/json_bigint.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dance_scoring/theme.dart';
import 'package:dance_scoring/widgets/snackbar.dart';
import 'package:dance_scoring/utils/check.dart';
import 'package:dance_scoring/utils/user_info.dart';
import 'package:dance_scoring/utils/user_info_container.dart';
import 'package:dance_scoring/utils/result_code.dart';
import 'package:dance_scoring/utils/BackendSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginMobileNumController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeMobileNum = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeMobileNum.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeMobileNum,
                          controller: loginMobileNumController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: '请输入手机号',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          onSubmitted: (_) {
                            focusNodePassword.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodePassword,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: const TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: '请输入密码',
                            hintStyle: const TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            login(this, context);
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      '登录',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () {
                    login(this, context);
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  '忘记密码？',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('QQ button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.qq,
                      //color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => CustomSnackBar(
                      context, const Text('Wechat button pressed')),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.weixin,
                      //color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  Future<void> login(_SignInState handler, BuildContext context) async {

    //校验
    String mobilenum = handler.loginMobileNumController.text;
    String password = handler.loginPasswordController.text;
    if(!isMobile(mobilenum)){
      Fluttertoast.showToast(
          msg: "请输入正确的手机号格式！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      return;
    }
    if(password==null || password==""){
      Fluttertoast.showToast(
          msg: "密码不能为空！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      return;
    }

    UserInfo user = UserInfo(user_telephone: mobilenum, user_password: password, user_id: BigInt.from(0));
    try {
      http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'/users/${user.user_telephone}/${user.user_password}'), headers: {"Accept": "application/json; charset=utf-8", "Content-Type": "application/json; charset=utf-8"}));
      String str = await response.body.toString();
      final map = decodeJson(str) as Map<String, dynamic>;

      if(map['code'].toSigned(64).toInt() == getResultCode(ResultCode.SUCCESS))
      {
        Fluttertoast.showToast(
            msg: "登录成功！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
        user = UserInfo.fromMap(map['data']);
        if(user.user_avatar != "" )
        {
          String avatar_path = user.user_avatar;
          final tempDir = await getTemporaryDirectory(); // 获取应用程序缓存目录路径
          Assets.tempDir = tempDir.path;
          final tempFile = File('${tempDir.path}/${user.user_avatar}'); // 在缓存目录中创建临时文件
          if (await tempFile.exists()) {
            print("Already existed!");
            //await downloadAvatarByUserTel(tempFile, user.user_telephone);
            Assets.avatarPath = tempFile.path;
          }
          else
          {
            await downloadAvatarByUserTel(tempFile, user.user_telephone);
          }

        }
        else {
          ;
        }


        UserInfoContainer.of(context)!.setUserInfo(user);

        final prefs = await SharedPreferences.getInstance();
        final userData = encodeJson({
          'user_id': user.user_id,
          //'expiryDate': _expiryDate.toIso8601String(),
        } as Map<String, dynamic>);
        prefs.setString('userData', userData);

        Navigator.pop(context);
        Navigator.of(context).pushNamed('/user');
      }
      else
      {
        Fluttertoast.showToast(
            msg: "请输入正确的手机号或密码！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.white);
      }
      return ;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "请求错误: $e",
          gravity: ToastGravity.CENTER,
          textColor: Colors.white);
      return ;
    }
  }

  Future<void> downloadAvatarByUserTel(File tempFile, String user_telephone) async
  {
    try
    {
      http.Response response = (await http.get(Uri.parse(UrlConstants.apiUrl+'//users/downloadAvatarByTel/${user_telephone}')));
      await tempFile.writeAsBytes(response.bodyBytes);
      Assets.avatarPath = tempFile.path;

    }catch (e) {
      print('请求错误: $e');
    }

    return;
  }
}