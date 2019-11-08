import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/my_loved_musics_list/my_loved_musics_list.dart';
import 'package:netease_flutter/pages/playlist/playlist.dart';
import 'package:netease_flutter/pages/rank_list/rank_list.dart';
import 'package:netease_flutter/pages/recommend_songs/recommend_songs.dart';
import 'package:netease_flutter/pages/search_result/search_result.dart';
import 'package:netease_flutter/pages/song_detail/song_detail.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:provider/provider.dart';

import 'pages/advertising/advertising.dart';
import 'pages/comment/comment.dart';
import 'pages/home/home.dart';
import 'pages/latest_song/latest_song.dart';
import 'pages/login/login.dart';
import 'pages/local_musics/local_musics.dart';
import 'pages/personal_fm/personal_fm.dart';
import 'pages/play_record/play_record.dart';
import 'pages/playlist_of_user/playlist_of_user.dart';
import 'pages/playlist_square/playlist_square.dart';
import 'pages/search/search.dart';

import './shared/widgets/dialog/loading_dialog.dart';
import 'pages/user/user.dart';
import 'shared/player/player_position.dart';
import 'shared/player/player_repeat_mode.dart';
import 'shared/player/player_song_demand.dart';

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
        ChangeNotifierProvider(builder: (_) => PlayerStatusNotifier()),
        //播放模式观察者
        ChangeNotifierProvider(builder: (_) => PlayerRepeatMode()),
        // 当前播放歌曲、点歌列表、歌词；
        ChangeNotifierProvider(builder: (_) => PlayerSongDemand()),
        // 播放位置。
        ChangeNotifierProvider(builder: (_) => PlayerPosition()),        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,

        ],
        theme: Theme.of(context).copyWith(
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(40, 67, 84, 1),
          textSelectionColor: Color.fromRGBO(38, 150, 167, 1),
          scaffoldBackgroundColor: Color.fromRGBO(17, 60, 103, 1),
          disabledColor: Colors.white24,
          accentColor: Colors.teal,
          iconTheme: IconThemeData(
            color: Colors.red
          ),
          highlightColor: Colors.black12,
          // 水波纹样式
          splashColor: Colors.black.withOpacity(0.2),
          // 播放条滑块样式
          sliderTheme: SliderThemeData(
            trackHeight: 1.5,
            activeTrackColor: Colors.tealAccent,
            inactiveTrackColor: Colors.grey,
            thumbColor: Colors.white
          ),
          // hintColor: Colors.redAccent,
          inputDecorationTheme: InputDecorationTheme(
            // border: InputBorder.none,
            
            hintStyle: TextStyle(
              color: Color.fromRGBO(103, 128, 141, 1),
              
            )
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Color.fromRGBO(54, 99, 122, 1),
            titleTextStyle: TextStyle(
              color: Color.fromRGBO(137, 170, 187, 1),
            ),
            contentTextStyle: TextStyle(
              color: Color.fromRGBO(137, 170, 187, 1),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0)
            )
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
        initialRoute: "advertising",
        routes: {
          // 广告引导页
          'advertising': (BuildContext context) => new NeteaseAdvertising(),
          // 登录页
          'login': (BuildContext context) => new NeteaseLogin(),
          // 主页
          'home': (BuildContext context) => new NeteaseHome(),
          // 歌曲详情
          'song_detail': (BuildContext context) => new NeteaseSongDetail(),
          // 歌单界面
          'playlist': (BuildContext context) => new NeteasePlaylist(),
          // 每日推荐歌曲
          'commend_songs': (BuildContext context) => new NeteaseRecommendSongs(),
          // 最新音乐
          'latest_song': (BuildContext context) => new NeteaseLatestSong(),
          // 私人FM
          'personal_fm': (BuildContext context) => new NeteasePersonalFm(),
          // 歌单广场
          'playlist_square': (BuildContext context) => new NeteasePlaylistSquare(),
          // 搜索界面
          'search': (BuildContext context) => new NeteaseSearch(),
          // 搜索结果界面
          'search_result': (BuildContext context) => new NeteaseSearchResult(),
          // 本地音乐
          'local_musics': (BuildContext context) => new LocalMusics(),
          // 排行榜
          'rank_list': (BuildContext context) => new NeteaseRankList(),
          // 评论界面 【需要传入Id和评论对象类型】
          'comment': (BuildContext context) => new NeteaseComment(),
          // 用户主页
          'user': (BuildContext context) => new NeteaseUser(),
          // 用户播放记录 [userId: 用户id, nickname: 用户昵称]
          'play_record': (BuildContext context) => new NeteasePlayRecord(),
          // 用户的歌单界面 [userId: 用户id, nickname: 用户昵称]
          'playlist_of_user': (BuildContext context) => new NeteasePlaylistOfUser(),
          //“加载中”弹框
          'loading': (BuildContext context) => new LoadingDialog(),
          //我的歌单
          'my_loved_musics_list': (BuildContext context) => new MyLovedMusicsList(),
        }
      )
    );
  }
}
