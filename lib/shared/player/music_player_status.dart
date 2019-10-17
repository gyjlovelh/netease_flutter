

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';

class MusicPlayerStatus with ChangeNotifier {

    // 背景播放器
  AudioPlayer _player;

  AudioPlayerState _playStatus = AudioPlayerState.STOPPED;

  bool _completed;
  bool get completed => _completed;

  // 播放模式
  int _repeatNum = 0;
  RepeatMode _repeatMode = RepeatMode.LIST;
  RepeatMode get repeatMode => _repeatMode;

  String _url;

  MusicPlayerStatus() {
    this._player = new AudioPlayer();
    this._completed = false;

    _player.onAudioPositionChanged.listen((Duration duration) {
      
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState state) {
      this._playStatus = state;
      // notifyListeners();
      print(state);
    });
  }

  AudioPlayerState get playerState => this._playStatus;

  void setSongUrl(String url) {
    if (_player.state != AudioPlayerState.STOPPED) {
      _player.stop();
    }
    this._url = url;
    this._completed = true;
    notifyListeners();
  }

  void play() async {
    await this._player.play(_url);
    this._playStatus = AudioPlayerState.PLAYING;
    notifyListeners();
  }

  void pause() async {
    await this._player.pause();
    this._playStatus = AudioPlayerState.PAUSED;
    notifyListeners();
  }

  void stop() async {
    await this._player.stop();
    this._playStatus = AudioPlayerState.STOPPED;
  }

  /*
   * 切换播放模式
   */
  void changeRepeatMode() {
    _repeatNum = ++_repeatNum % 3;
    this._repeatMode = [RepeatMode.LIST, RepeatMode.RANDOM, RepeatMode.SINGLE][_repeatNum];
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
