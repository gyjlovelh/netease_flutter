import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netease_flutter/pages/playlist/playlist.dart';
import 'package:netease_flutter/pages/song_detail/song_detail.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:provider/provider.dart';

import 'pages/home/home.dart';
import 'pages/login/login.dart';
import 'pages/local_musics/local_musics.dart';
import 'pages/playlist_square/playlist_square.dart';

void main() async {

  await Global.init();
  runApp(NeteaseApp());
}

class NeteaseApp extends StatefulWidget {
  @override
  _NetState createState() => _NetState();
}

class _NetState extends State<NeteaseApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 
        ChangeNotifierProvider(builder: (_) => MusicChangeNotifier()),
        ChangeNotifierProvider(builder: (_) => MusicPlayerStatus()), 
      ],
      child: Consumer<MusicChangeNotifier>(
        builder: (context, currentMusic, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,

            ],
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
              'playlist': (BuildContext context) => new NeteasePlaylist(),
              // 歌单广场
              'playlist_square': (BuildContext context) => new NeteasePlaylistSquare(),
              // 本地音乐
              'local_musics': (BuildContext context) => new LocalMusics(),
            }
          );
        },
      ),
    );
  }
}
