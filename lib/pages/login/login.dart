import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import '../../shared/states/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'input.dart';

class NeteaseLogin extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<NeteaseLogin> {
  TextEditingController phontController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _rememberMe = true;

  Future<bool> _requestPop() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(content: new Text('退出网易云音乐？'), actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: new Text(
            '取消',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle.color
            ),
          )
        ),
        new FlatButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: new Text(
            '确定',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle.color
            ),
          )
        )
      ]),
    );
    return new Future.value(false);
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 13.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(150),
      height: 1.0,
      color: Colors.grey.withOpacity(0.2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil.getInstance().setWidth(600),
              child: ClipPath(
                clipper: BottomClipper(),
                child: Container(
                    child: Image.asset(
                  'assets/images/login_bg.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
              ),
            ),
            Center(
              child: Container(
                width: ScreenUtil.getInstance().setWidth(750),
                height: ScreenUtil.getInstance().setHeight(734),
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(25.0),
                  right: ScreenUtil.getInstance().setWidth(25.0),
                  top: ScreenUtil.getInstance().setWidth(600.0)),
                  padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(50.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      NeteaseInput(
                        controller: phontController,
                        hintText: '请填写手机号',
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        
                      ),
                      NeteaseInput(
                        controller: passwordController,
                        hintText: '请填写密码',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: _rememberMe,
                                activeColor: Theme.of(context).textSelectionColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Text('记住我',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text('忘记密码?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              )),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(10.0)),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: ScreenUtil.getInstance().setWidth(80.0),
                        child: FlatButton(
                          child: Text(
                            '登 录',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).textSelectionColor,
                          onPressed: _onLogin,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(20.0)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          horizontalLine(),
                          Text('其他方式登录',
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(20.0),
                                  color: Colors.grey)),
                          horizontalLine()
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil.getInstance().setWidth(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CustomLoginTypeIcon(0xe623),
                            CustomLoginTypeIcon(0xe606),
                            CustomLoginTypeIcon(0xe681)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            )
          ],
        ),
      ))
    );
  }

  _onLogin() async {
    if (phontController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      // 跳转到首页
      RequestService service = RequestService.getInstance(context: context);
      ProfileModel profile = await service.login(phone: phontController.text, password: passwordController.text);
      // 缓存用户信息
      Global.updateProfile(profile);

      //缓存用户信息
      saveUserInfo(profile);

      Navigator.of(context).pushNamed('home');

    } else {
      showLoginErrorDialog('请填写手机号和密码');
    }
  }

  //缓存用户信息
  void saveUserInfo(ProfileModel profile) {
    SharedPreferences sp = Global.mSp;
      sp.setInt(Constant.authStatus, profile.authStatus);
      sp.setBool(Constant.followed, profile.followed);
      sp.setString(Constant.avatarUrl, profile.avatarUrl);
      sp.setInt(Constant.accountStatus, profile.accountStatus);
      sp.setInt(Constant.gender, profile.gender);
      sp.setInt(Constant.birthday, profile.birthday);
      sp.setInt(Constant.userId, profile.userId);
      sp.setInt(Constant.userType, profile.userType);
      sp.setString(Constant.nickname, profile.nickname);
      sp.setString(Constant.signature, profile.signature);
      sp.setString(Constant.description, profile.description);
      sp.setString(Constant.detailDescription, profile.detailDescription);
      sp.setInt(Constant.avatarImgId, profile.avatarImgId);
      sp.setInt(Constant.backgroundImgId, profile.backgroundImgId);
      sp.setString(Constant.backgroundUrl, profile.backgroundUrl);
      sp.setInt(Constant.authority, profile.authority);
      sp.setBool(Constant.mutual, profile.mutual);
      sp.setInt(Constant.djStatus, profile.djStatus);
      sp.setInt(Constant.vipType, profile.vipType);
  }

  Future<bool> showLoginErrorDialog(String content) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('提示'),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('确认'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4 * 3, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomLoginTypeIcon extends StatelessWidget {
  final int pointer;

  CustomLoginTypeIcon(
    this.pointer,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        IconData(pointer, fontFamily: 'iconfont'),
        size: ScreenUtil.getInstance().setSp(48.0),
        color: Theme.of(context).textSelectionColor.withOpacity(0.8),
      ),
    );
  }
}
