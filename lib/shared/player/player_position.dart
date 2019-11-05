

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';

class  PlayerPosition extends ChangeNotifier {
  // 当前位置
  Duration _current = new Duration();
  Duration get current => _current;
  Duration get duration => Global.player.duration ?? 0;

  // 当前位置【格式化】
  String _currentTime = '00:00';
  String get currentTime => _currentTime;
  String get durationTime => Global.player.duration == null ? '00:00' :"${Global.player.duration.inMinutes.toString().padLeft(2, '0')}:${(Global.player.duration.inSeconds % 60).toString().padLeft(2, '0')}";

  // 播放进度【百分比】
  double _progress = 0;
  double get progress => _progress;

  PlayerPosition() {
    Global.player.onAudioPositionChanged.listen((Duration d) {
      _current = d;
      _progress = d.inMilliseconds / duration.inMilliseconds;
      _currentTime = "${(d.inSeconds ~/ 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
      notifyListeners();
    });

    Global.player.onPlayerStateChanged.listen((AudioPlayerState state) {
      print("state:$state");
      if (state == AudioPlayerState.COMPLETED || state == AudioPlayerState.STOPPED) {
        _current = new Duration(seconds: 0);
        _currentTime = '00:00';

        _progress = 0;
        notifyListeners();
      }
    });
  }
}