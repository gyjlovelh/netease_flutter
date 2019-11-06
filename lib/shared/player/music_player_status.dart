
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';

class PlayerStatusNotifier with ChangeNotifier {

  // 背景播放器
  AudioPlayer _player;

  // 播放状态
  AudioPlayerState _playStatus = Global.player.state;
  AudioPlayerState get playerState => _playStatus;

  PlayerStatusNotifier() {
    this._player = Global.player;

    this._player.onPlayerStateChanged.listen((AudioPlayerState state) {
      _playStatus = state;
      notifyListeners();
    });
  }

  Future play() async {
    await this._player.play("${Global.getCurrentMusic().url}");
  }

  //播放本地音乐
  Future playLocal(String path) async {
    await this._player.play(path,isLocal: true);
    this._playStatus = AudioPlayerState.PLAYING;
  }

  Future pause() async {
    await this._player.pause();
  }

  Future stop() async {
    await this._player.stop();
  }
  
  
}

