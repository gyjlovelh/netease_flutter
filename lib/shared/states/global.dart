import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/event/event.dart';
import 'package:netease_flutter/shared/player/player_repeat_mode.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class Global {

  static String sDCardDir; //sd卡项目目录
  static List<String> mMp3Files; //本地音乐列表(存的是sd卡路径))
  static SharedPreferences mSp; //sp 用来存储用户登录信息

  ///app栏、主体内容区域、播放器所占比例
  static const double APPBAR_SCALE = 1.6 / 14;
  static const double PLAYER_SCALE = 1.2 / 14;
  static const double MAIN_SCALE = 11.2 / 14;

  static AudioPlayer player;

  static Future init() async {
    // 强制竖屏。
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // 初始化http请求
    RequestService.init(baseUrl: 'http://106.14.154.205:3000');
    // 同事滴服务器。要屌一点！
    // RequestService.init(baseUrl: 'http://47.99.212.26:3000');

    //初始化SD卡根目录
    sDCardDir = (await getExternalStorageDirectory()).path;
    print('sDCardDir = ' + sDCardDir);
    
    mMp3Files = List<String>();

    //初始化sp
    mSp = await SharedPreferences.getInstance();

    // 初始化音频播放器
    _initAudioPlayer();
  }

  // 返回当前播放模式
  static RepeatMode getRepeatMode() {
    final index = mSp.getInt('netease_cache_repeat_mode');
    if (index != null) {
      return RepeatMode.values[index];
    }
    return RepeatMode.LIST;
  }

  // 判断用户是否登录
  static bool get isLogin => profile != null;

  // 获取当前播放对象类型，默认为播放音乐
  static int get playMode => mSp.getInt('netease_cache_play_mode') ?? 1;

  // 当前登录用户
  static ProfileModel get profile {
    String _profileString = mSp.getString('netease_cache_profile');
    if (_profileString != null && _profileString.isNotEmpty) {
      return ProfileModel.fromJson(json.decode(_profileString));
    }
    return null;
  }

  // 更新用户信息
  static updateProfile(ProfileModel profile) async {
    await mSp.setString('netease_cache_profile', json.encode(profile.toJson()));
  }

  // 更新播放模式
  static updateRepeatMode(RepeatMode mode) async {
    await mSp.setInt('netease_cache_repeat_mode', mode.index);
  }

  // 获取当前正在播放的音乐
  static SongModel getCurrentMusic() {
    String song = mSp.getString('netease_cache_current_song');
    if (song == null) {
      return null;
    }
    return SongModel.fromJson(json.decode(song)); 
  }

  // 更新当前播放音乐到缓存
  static updateCurrentMusic(SongModel song) async {
    await mSp.setString('netease_cache_current_song', json.encode(song.toJson()));
  }

  // 获取缓存歌词
  static List getLyric() {
    List<String> list = mSp.getStringList('netease_cache_lyric') ?? [];
    return list.map((item) => json.decode(item)).toList();
  }

  // 缓存歌词
  static updateLyric(List lyric) async {
    await mSp.setStringList('netease_cache_lyric', lyric.map((item) => json.encode(item)).toList());
  }

  // 获取当前列表
  static List<SongModel> getMusicList() {
    List<String> list = mSp.getStringList('netease_cache_music_list') ?? [];
    return list.map((item) => SongModel.fromJson(json.decode(item))).toList();
  }

  // 更新当前播放列表
  static updateMusicList(List<SongModel> list) async {
    await mSp.setStringList('netease_cache_music_list', list.map((item) => json.encode(item.toJson())).toList());
  }

  // 获取当前FM列表
  static List<SongModel> getFmList() {
    List<String> list = mSp.getStringList('netease_cache_fm_list') ?? [];
    return list.map((item) => SongModel.fromJson(json.decode(item))).toList();
  }

  // 更新当前FM列表
  static updateFmList(List<SongModel> list) async {
    await mSp.setStringList('netease_cache_fm_list', list.map((item) => json.encode(item.toJson())).toList());
  }
  /// 切换播放对象 [ 1:播放音乐; 2:播放FM; ]
  static setPlayMode(int mode) async {
    await mSp.setInt('netease_cache_play_mode', mode);
  }

  static void _initAudioPlayer() {
    final event = NeteaseEvent.getInstance();
    player = new AudioPlayer();
    // 监听播放位置变更事件
    player.onAudioPositionChanged.listen((Duration duration) {
      event.publish('netease.player.position.change', duration);
    });
    // 监听播放状态变更事件
    player.onPlayerStateChanged.listen((AudioPlayerState state) {
      event.publish('netease.player.state.change', state);
    });
  }
}

//全局常量
class Constant {
  static final String authStatus = 'authStatus';
  static final String followed = 'followed';
  static final String avatarUrl = 'avatarUrl';
  static final String accountStatus = 'accountStatus';
  static final String gender = 'gender';
  static final String birthday = 'birthday';
  static final String userId = 'userId';//用户id
  static final String userType = 'userType';
  static final String nickname = 'nickname';//昵称
  static final String signature = 'signature';
  static final String description = 'description';
  static final String detailDescription = 'detailDescription';
  static final String avatarImgId = 'avatarImgId';
  static final String backgroundImgId = 'backgroundImgId';
  static final String backgroundUrl = 'backgroundUrl';
  static final String authority = 'authority';
  static final String mutual = 'mutual';
  static final String djStatus = 'djStatus';
  static final String vipType = 'vipType';
}
