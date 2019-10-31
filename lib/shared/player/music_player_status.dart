

import 'dart:math';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class PlayerStatusNotifier with ChangeNotifier {

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

  // 当前音乐
  SongModel _song;
  SongModel get currentMusic => _song;

  // 歌词
  List _lyric;
  List get lyric => _lyric;

  // 加载歌曲
  void loadMusic(SongModel song) async {
    if (_playStatus == AudioPlayerState.PLAYING) {
      stop();
    }
    this._setCurrentMusic(song);

    play();

    final lyric = await RequestService.getInstance(context: null).getSongLyric(song.id);
    this._setMusiclyric(lyric);
  }

  // 播放列表
  List<SongModel> _musicList = [];
  List<SongModel> get musicList => _musicList;

  PlayerStatusNotifier() {
    this._player = new AudioPlayer();

    _player.onAudioPositionChanged.listen((Duration duration) {
      this._current = duration.inSeconds;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState state) {
      this._playStatus = state;
      print('$state');
      if (state == AudioPlayerState.COMPLETED) {
        print('播放结束');
        // 播放下一首
        next();
      }
      notifyListeners();
    });
  }

  AudioPlayerState get playerState => this._playStatus;

  Future play() async {
    await this._player.play("${_song.url}");
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
  
  // 上一首⏮
  void prev() async {
    int index = musicList.map((item) => item.id).toList().indexOf(currentMusic.id);
    stop();
    ///TODO,上一首定位到历史播放的前一位。
    if (index == 0) {
      loadMusic(musicList.last);
    } else {
      loadMusic(musicList[index - 1]);
    }
    play();
  }
  // 下一首⏭
  void next() async {
    int index = musicList.map((item) => item.id).toList().indexOf(currentMusic.id);
    stop();
    var target;
    if (repeatMode == RepeatMode.RANDOM) {
      target = musicList[Random().nextInt(musicList.length)];
    } else {
      if (index == musicList.length - 1) {
        target = musicList.first;
      } else {
        target = musicList[index + 1];
      }
    }
    loadMusic(target);
    play();
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
    notifyListeners();
  }

  void removeMusicItem(SongModel song) {
    int index = _musicList.indexWhere((item) => item.id == song.id);
    if (index >= 0 && index < _musicList.length) {
      _musicList.removeAt(index);
      notifyListeners();
    }
  }

  // 选择歌单播放
  void choosePlayList(List<SongModel> list) {
    _musicList = list;
    notifyListeners();
  }

  void _setCurrentMusic(SongModel song) {
    this._song = song;
    notifyListeners();
  }

  void _setMusiclyric(List lyric) {
    this._lyric = lyric;
    notifyListeners();
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
