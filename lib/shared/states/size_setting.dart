import 'package:flutter/foundation.dart';

///由于ScreenUtil设置的字体在大屏设备中显示不符合预期。
///为了实现不同分辨率条件下的自适应字体显示。即大屏中字体略大于小屏
///统一在此处配置应用中文字字体大小；
///从大到小分为七级。
///`AppBar`中`title`的字体大小选用`size_16`。`subtitle`字体大小选用`size_12`
///普通`ListTile`中`title`的字体大小选用`size_14`。`subtitle`字体大小选用`size_10`
///歌词字体大小为`size_14`
class SizeSetting {
  static double size_20 = 20.0;

  static double size_18 = 18.0;

  static double size_16 = 16.0;

  static double size_14 = 14.0;

  static double size_12 = 12.0;

  static double size_10 = 10.0;

  static double size_8 = 8.0;

  static void init({
    @required double size20,
    @required double size18,
    @required double size16,
    @required double size14,
    @required double size12,
    @required double size10,
    @required double size8,
  }) {
    size_20 = size20;
    size_18 = size18;
    size_16 = size16;
    size_14 = size14;
    size_12 = size12;
    size_10 = size10;
    size_8 = size8;
  }
}