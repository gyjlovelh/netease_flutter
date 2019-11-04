

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';

class PlayerSongDemand extends ChangeNotifier {
  SongModel _music = Global.getCurrentMusic();
  List<SongModel> _list = Global.getMusicList();

  SongModel get currentMusic => _music;
  List<SongModel> get musicList => _list;

  List _lyric = []; 
  List get lyric => _lyric;

  // 加载歌曲
  loadMusic(SongModel song) async {
    if (Global.player.state == AudioPlayerState.PLAYING) {
      Global.player.stop();
    }
    this._music = song;
    await Global.player.play(song.url);
    Global.updateCurrentMusic(song);
    notifyListeners();

    // 发布歌词
    _lyric = await RequestService.getInstance(context: null).getSongLyric(song.id);
    notifyListeners();
  }

  // 追加歌曲待播放
  void addMusicItem(SongModel song) {
    _list.add(song);
    Global.updateMusicList(_list);
    notifyListeners();
  }

  // 移除歌曲
  void removeMusicItem(SongModel song) {
    int index = _list.indexWhere((item) => item.id == song.id);
    if (index >= 0 && index < _list.length) {
      _list.removeAt(index);
      Global.updateMusicList(_list);
      notifyListeners();
    }
  }

  // 选择歌单播放
  void choosePlayList(List<SongModel> list) {
    _list = list;
    Global.updateMusicList(_list);
    notifyListeners();
  }
}