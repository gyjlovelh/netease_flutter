import 'package:flutter/services.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class Global {

  static String sDCardDir; //sd卡项目目录
  static List<String> mMp3Files; //本地音乐列表(存的是sd卡路径))
  static SharedPreferences mSp; //sp 用来存储用户登录信息

  // app栏、主体内容区域、播放器所占比例
  static const double APPBAR_SCALE = 1.6 / 14;
  static const double PLAYER_SCALE = 1.2 / 14;
  static const double MAIN_SCALE = 11.2 / 14;

  static Future init() async {
    // 强制竖屏。
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // 初始化http请求
    RequestService.init(baseUrl: 'http://106.14.154.205:3000');
    // 同事滴服务器。要屌一点！
    // RequestService.init(baseUrl: 'http://47.99.212.26:3000');

    //初始化SD卡根目录
    sDCardDir = (await getExternalStorageDirectory()).path;
    print('sDCardDir = ' + sDCardDir);
    
    mMp3Files = List<String>();

    //初始化sp
    mSp = await SharedPreferences.getInstance();
  }
}

//全局常量
class Constant {
  static final String authStatus = 'authStatus';
  static final String followed = 'followed';
  static final String avatarUrl = 'avatarUrl';
  static final String accountStatus = 'accountStatus';
  static final String gender = 'gender';
  static final String birthday = 'birthday';
  static final String userId = 'userId';//用户id
  static final String userType = 'userType';
  static final String nickname = 'nickname';//昵称
  static final String signature = 'signature';
  static final String description = 'description';
  static final String detailDescription = 'detailDescription';
  static final String avatarImgId = 'avatarImgId';
  static final String backgroundImgId = 'backgroundImgId';
  static final String backgroundUrl = 'backgroundUrl';
  static final String authority = 'authority';
  static final String mutual = 'mutual';
  static final String djStatus = 'djStatus';
  static final String vipType = 'vipType';
}
