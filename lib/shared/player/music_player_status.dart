

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:provider/provider.dart';

import 'music_change.dart';

class MusicPlayerStatus with ChangeNotifier {

  // 背景播放器
  AudioPlayer _player;
  AudioPlayer get audioPlayer => _player;
  
  // 播放状态
  AudioPlayerState _playStatus = AudioPlayerState.STOPPED;

  // 播放当前位置和总时长
  int _current = 0;
  int get current => _current;
  int get duration => _player.duration.inSeconds;

  // 播放模式
  int _repeatNum = 0;
  RepeatMode _repeatMode = RepeatMode.LIST;
  RepeatMode get repeatMode => _repeatMode;

  // 播放列表
  List<SongModel> _musicList = [];
  List<SongModel> get musicList => _musicList;

  MusicPlayerStatus() {
    this._player = new AudioPlayer();

    _player.onAudioPositionChanged.listen((Duration duration) {
      this._current = duration.inSeconds;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState state) {
      this._playStatus = state;
      notifyListeners();
    });
  }

  AudioPlayerState get playerState => this._playStatus;

  Future play(String url) async {
    await this._player.play(url);
    this._playStatus = AudioPlayerState.PLAYING;
    // notifyListeners();
  }

  //播放本地音乐
  Future playLocal(String path) async {
    await this._player.play(path,isLocal: true);
    this._playStatus = AudioPlayerState.PLAYING;
    // notifyListeners();
  }

  Future pause() async {
    await this._player.pause();
    this._playStatus = AudioPlayerState.PAUSED;
    // notifyListeners();
  }

  Future stop() async {
    await this._player.stop();
    this._current = 0;
    this._playStatus = AudioPlayerState.STOPPED;
    // notifyListeners();
  }

  /*
   * 切换播放模式
   */
  void changeRepeatMode() {
    _repeatNum = ++_repeatNum % 3;
    this._repeatMode = [RepeatMode.LIST, RepeatMode.RANDOM, RepeatMode.SINGLE][_repeatNum];
    notifyListeners();
  }

  // 追加歌曲待播放
  void addMusicItem(SongModel song) {
    _musicList.add(song);
  }

  void removeMusicItem(SongModel song) {
    int index = _musicList.indexWhere((item) => item.id == song.id);
    if (index >= 0 && index < _musicList.length) {
      _musicList.removeAt(index);
    }
  }

  // 选择歌单播放
  void choosePlayList(List<SongModel> list) {
    _musicList = list;
  }
}

enum RepeatMode {
  // 列表循环
  LIST,
  // 随机播放
  RANDOM,
  // 单曲循环
  SINGLE
}
