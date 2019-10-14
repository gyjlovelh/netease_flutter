import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netease_flutter/pages/playlist/playlist.dart';
import 'package:netease_flutter/pages/song_detail/song_detail.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

import 'pages/home/home.dart';
import 'pages/login/login.dart';

void main() async {
  // 强制竖屏。
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(NeteaseApp());
}

class NeteaseApp extends StatefulWidget {
  @override
  _NetState createState() => _NetState();
}

class _NetState extends State<NeteaseApp> {

  @override
  Widget build(BuildContext context) {

    // var screenInstance = ScreenUtil.getInstance();
    RequestService.init(baseUrl: 'http://106.14.154.205:3000');

    

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColorLight: Colors.redAccent,
        primaryColor: Colors.redAccent,
        accentColor: Colors.teal,
        fontFamily: 'iconfont',
        iconTheme: IconThemeData(
          color: Colors.red
        ),
        // tabbar样式
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 0.1,
              color: Colors.white10
            )
          ),
          unselectedLabelColor: Colors.black.withOpacity(0.6),
          unselectedLabelStyle: TextStyle(
          ),
          labelPadding: EdgeInsets.all(1.0),
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold
          )
        )
      ),
      initialRoute: "login",
      routes: {
        // 登录页
        'login': (BuildContext context) => new NeteaseLogin(),
        // 主页
        'home': (BuildContext context) => new NeteaseHome(),
        // 歌曲详情
        'song_detail': (BuildContext context) => new NeteaseSongDetail(),
        // 歌单界面
        'playlist': (BuildContext context) => new NeteasePlaylist()
      }
    );
  }
}
