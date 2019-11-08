

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';

class  PlayerPosition extends ChangeNotifier {
  // 当前位置
  Duration _current = new Duration();
  Duration get current => _current;
  Duration _duration = new Duration();
  Duration get duration => _duration;

  // 当前位置【格式化】
  String _currentTime = '00:00';
  String get currentTime => _currentTime;
  String _durationTime = '00:00';
  String get durationTime => _durationTime;

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

    Global.player.onDurationChanged.listen((Duration d) {
      _duration = d;
      _durationTime = "${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
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