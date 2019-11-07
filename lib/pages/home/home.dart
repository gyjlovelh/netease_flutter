import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'find/find.dart';
import 'user_center/user_center.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import '../../shared/widgets/player/player.dart';
import '../home/video/video.dart';

import 'drawer/drawer.dart';

class NeteaseHome extends StatefulWidget {

  @override
  _NeteaseHomeState createState() => _NeteaseHomeState();
}

class _NeteaseHomeState extends State<NeteaseHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    // 缓存FM播放列表
    _cachePmList();
  }

  Future<bool> _requestPop() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(content: new Text('退出网易云音乐？'), actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: new Text(
            '取消',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle.color
            ),
          )
        ),
        new FlatButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: new Text(
            '确定',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle.color
            ),
          )
        )
      ]),
    );
    return new Future.value(false);
  }

  @override
  Widget build(BuildContext context) {

    // 初始化屏幕逻辑宽高
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1340, allowFontScaling: true)..init(context);
    print("当前设备尺寸:${ScreenUtil.screenWidthDp}x${ScreenUtil.screenHeightDp}");
    if (ScreenUtil.screenWidthDp > 450.0) {
      SizeSetting.init(
      size20: 22.0,
      size18: 20.0,
      size16: 18.0,
      size14: 16.0,
      size12: 14.0,
      size10: 12.0,
      size8: 10.0,
    );
    } else {
      SizeSetting.init(
        size20: 20.0,
        size18: 18.0,
        size16: 16.0,
        size14: 14.0,
        size12: 12.0,
        size10: 10.0,
        size8: 8.0,
      );
    }

    ScreenUtil sc = ScreenUtil.getInstance();

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: globalKey,
        drawer: new NeteaseDrawer(),
        body: Container(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                height: ScreenUtil.statusBarHeight,
              ),
              // 顶部操作栏
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: sc.setHeight(1.0),
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  color: Theme.of(context).primaryColor
                ),
                height: 50.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: sc.setWidth(120.0),
                      height: 50.0,
                      child: IconButton(
                        icon: NeteaseIconData(
                          0xe77c, 
                          size: ScreenUtil.getInstance().setSp(36.0),
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          globalKey.currentState.openDrawer();
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: sc.setWidth(500.0),
                      child: TabBar(
                        controller: _tabController,
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600
                        ),
                        labelColor: Theme.of(context).textSelectionColor,
                        unselectedLabelColor: Colors.white70,
                        unselectedLabelStyle: TextStyle(
                          // fontSize: sc.setSp(34.0)
                        ),
                        tabs: <Widget>[
                          Text('我的'),
                          Text('发现'),
                          Text('云村'),
                          Text('视频')
                        ],
                      )
                    ),
                    Container(
                      height: 50.0,
                      width: sc.setWidth(120.0),
                      child: IconButton(
                        icon: NeteaseIconData(
                          0xe60c,
                          size: ScreenUtil.getInstance().setSp(36.0),
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('search');
                        },
                      ),
                    )
                  ],
                ),
              ),
              // 内容区域
              Container(
                // 设置皮肤
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/theme_1.jpg'
                    ),
                    fit: BoxFit.cover
                  )
                ),
                height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100.0,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    new NeteaseUserCenter(),
                    new NeteaseFind(),
                    Text('data3'),
                    new Video(),
                  ],
                ),
              ),
              // 底部播放栏
              Container(
                height: 50.0,
                child: new NeteasePlayer(),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _cachePmList() async {
    if (Global.getFmList().length == 0) {
      List songs = await RequestService.getInstance(context: context).getPersonalFm();
      Global.updateFmList(songs.map((item) => SongModel.fromJson(item)).toList());
    }
  }
}