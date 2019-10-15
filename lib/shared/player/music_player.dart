

import 'package:audioplayer/audioplayer.dart';
import 'package:netease_flutter/models/song.dart';

class NeteaseMusicController {
  // 当前选中歌曲信息
  SongModel currentMusicInfo;

  // 当前播放模式
  int repeatMode;

  // 背景播放器
  AudioPlayer player;

  // 实现单例模式
  static NeteaseMusicController _instance;
  NeteaseMusicController._() {
    player = new AudioPlayer();
    player.onAudioPositionChanged.listen((Duration duration) {
      // 监听播放进度变化
    });
    player.onPlayerStateChanged.listen((AudioPlayerState state) {
      // 监听播放状态变化
    });
  }

  static NeteaseMusicController getInstance() {
    if (_instance == null) {
      _instance = new NeteaseMusicController._();
    }
    return _instance;
  }

  Future<void> play() async {
    return player.play(currentMusicInfo.url);
  }

  Future<void> pause() async {
    return player.pause();
  }

  Stream<AudioPlayerState> get onPlayerStateChanged => player.onPlayerStateChanged;

  Stream<Duration> get onAudioPositionChanged => player.onAudioPositionChanged;

}
