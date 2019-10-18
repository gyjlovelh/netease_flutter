

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';

class MusicPlayerStatus with ChangeNotifier {

    // 背景播放器
  AudioPlayer _player;

  AudioPlayer get audioPlayer => _player;

  AudioPlayerState _playStatus = AudioPlayerState.STOPPED;

  int _current = 0;
  int get current => _current;

  int get duration => _player.duration.inSeconds;

  // 播放模式
  int _repeatNum = 0;
  RepeatMode _repeatMode = RepeatMode.LIST;
  RepeatMode get repeatMode => _repeatMode;

  MusicPlayerStatus() {
    this._player = new AudioPlayer();

    _player.onAudioPositionChanged.listen((Duration duration) {
      this._current = duration.inSeconds;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState state) {
      this._playStatus = state;
      // notifyListeners();
      print(state);
    });
  }

  AudioPlayerState get playerState => this._playStatus;

  Future play(String url) async {
    await this._player.play(url);
    this._playStatus = AudioPlayerState.PLAYING;
    notifyListeners();
  }

  Future pause() async {
    await this._player.pause();
    this._playStatus = AudioPlayerState.PAUSED;
    notifyListeners();
  }

  Future stop() async {
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
