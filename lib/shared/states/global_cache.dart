
import 'dart:convert';

import 'package:netease_flutter/models/banner.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/recomment_playlist.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

///缓存一些不是每次都需要重新加载的数据；
///如主页轮播图、推荐歌单、推荐单曲
class GlobalCache {
  static SharedPreferences _storage = Global.mSp ?? SharedPreferences.getInstance();

  // 拉取轮播图数据
  static List<BannerModel> getSwiperData() {
    List<String> list = _storage.getStringList('netease_cache_home_swiper') ?? [];
    return list.map<BannerModel>((item) => BannerModel.fromJson(json.decode(item))).toList();
  }

  // 缓存轮播图数据
  static void cacheSwiperData(List<BannerModel> list) async {
    await _storage.setStringList('netease_cache_home_swiper', list.map<String>((item) => json.encode(item.toJson())).toList());
  }

  // 获取首页推荐歌单缓存数据
  static List<RecommentPlaylistModel> getRecommendPlaylist() {
    List<String> list = _storage.getStringList('netease_cache_home_playlist') ?? [];
    return list.map<RecommentPlaylistModel>((item) => RecommentPlaylistModel.fromJson(json.decode(item))).toList();
  }

  // 缓存首页推荐歌单
  static void cacheRecommendPlaylist(List<RecommentPlaylistModel> list) async {
    await _storage.setStringList('netease_cache_home_playlist', list.map<String>((item) => json.encode(item.toJson())).toList());
  } 

  // 获取首页推荐新歌
  static List<SongModel> getRecommendSong() {
    List<String> list = _storage.getStringList('netease_cache_home_song') ?? [];
    return list.map<SongModel>((item) => SongModel.fromJson(json.decode(item))).toList();
  }

  // 缓存首页推荐新歌
  static void cacheRecommendSong(List<SongModel> list) async {
    await _storage.setStringList('netease_cache_home_song', list.map<String>((item) => json.encode(item.toJson())).toList());
  } 
}