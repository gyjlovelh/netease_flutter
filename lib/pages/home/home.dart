import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:provider/provider.dart';
import 'find/find.dart';
import 'user_center/user_center.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import '../../shared/widgets/player/player.dart';

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

    final stateController = Provider.of<MusicPlayerStatus>(context);

    // 计算各区域高度
    double screentHeight = ScreenUtil.getInstance().height;
    double topActionHeight = screentHeight * 1.6 / 14;
    double footerHeight = screentHeight * 1.2 / 14;
    double mainAreaHeight = screentHeight * (14 - 1.6 - 1.2) / 14;

    return Scaffold(
      key: globalKey,
      drawer: new NeteaseDrawer(),
      body: Container(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // 顶部操作栏
            Container(
              padding: EdgeInsets.only(top: sc.setHeight(50.0)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: sc.setHeight(1.0),
                    color: Colors.grey[200]
                  )
                )
              ),
              height: sc.setHeight(topActionHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: sc.setWidth(120.0),
                    child: IconButton(
                      // icon: Icon(Icons.list, size: ScreenUtil.getInstance().setSp(50.0)),
                      icon: NeteaseIconData(
                        0xe77c, 
                        size: ScreenUtil.getInstance().setSp(36.0),
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        globalKey.currentState.openDrawer();
                      },
                    ),
                  ),
                  Container(
                    height: topActionHeight - 50.0,
                    width: sc.setWidth(500.0),
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: TextStyle(
                        fontSize: sc.setSp(36.0),
                        fontWeight: FontWeight.bold
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: sc.setSp(34.0)
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
                    height: topActionHeight - 50.0,
                    width: sc.setWidth(120.0),
                    child: IconButton(
                      icon: NeteaseIconData(
                        0xe60c,
                        size: ScreenUtil.getInstance().setSp(36.0),
                        color: Colors.black87,
                      ),
                      onPressed: () {},
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
                    'assets/images/theme.jpeg'
                  ),
                  fit: BoxFit.cover
                )
              ),
              height: sc.setHeight(mainAreaHeight),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  new NeteaseUserCenter(),
                  new NeteaseFind(),
                  Text('data3'),
                  Text('data4'),
                ],
              ),
            ),
            // 底部播放栏
            Container(
              height: sc.setHeight(footerHeight),
              child: new NeteasePlayer(),
            ),
          ],
        ),
      ),
    );
  }
}