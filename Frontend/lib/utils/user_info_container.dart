import 'package:dance_scoring/utils/user_info.dart';
import 'package:flutter/material.dart';
class UserInfoInherited extends InheritedWidget {
  final _UserInfoContainerState data;

  const UserInfoInherited({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(UserInfoInherited old) {
    return true;
  }
}

class UserInfoContainer extends StatefulWidget {
  UserInfo user;
  final Widget child;
  UserInfoContainer({Key? key, required this.user, required this.child});

  @override
  State<StatefulWidget> createState() {
    return new _UserInfoContainerState();
  }

  static _UserInfoContainerState of(BuildContext context) {
    final UserInfoInherited inheritedConfig = context.dependOnInheritedWidgetOfExactType<UserInfoInherited>() as UserInfoInherited;
    return inheritedConfig.data;
  }
}

class _UserInfoContainerState extends State<UserInfoContainer> {

  void setUserInfo(UserInfo newUser) {
    setState(() {
      widget.user = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new UserInfoInherited(
      data: this,
      child: widget.child,
    );
  }
}