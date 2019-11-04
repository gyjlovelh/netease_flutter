import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  }

  @override
  Widget build(BuildContext context) {

    // 初始化屏幕逻辑宽高
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1340, allowFontScaling: true)..init(context);

    ScreenUtil sc = ScreenUtil.getInstance();

    return Scaffold(
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
                        fontSize: sc.setSp(34.0),
                        fontWeight: FontWeight.bold
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
    );
  }
}