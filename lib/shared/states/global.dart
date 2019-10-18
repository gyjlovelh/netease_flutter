import 'package:flutter/services.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class Global {

  // app栏、主体内容区域、播放器所占比例
  static const double APPBAR_SCALE = 1.6 / 14;
  static const double PLAYER_SCALE = 1.2 / 14;
  static const double MAIN_SCALE = 11.2 / 14;

  static Future init() async {
    // 强制竖屏。
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    // 初始化http请求
    RequestService.init(baseUrl: 'http://106.14.154.205:3000');

  }
}
