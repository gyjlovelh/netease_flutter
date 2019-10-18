import 'package:flutter/services.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class Global {

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
