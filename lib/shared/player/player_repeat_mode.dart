

import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';

class PlayerRepeatMode extends ChangeNotifier {
  RepeatMode _mode = Global.getRepeatMode() ?? RepeatMode.LIST;

  RepeatMode get repeatMode => _mode;

  void changeRepeatMode() {
    this._mode = RepeatMode.values[(_mode.index + 1) % 3];
    Global.updateRepeatMode(this._mode);
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
