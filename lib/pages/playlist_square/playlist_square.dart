import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/player/player.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

import 'playlist_recommend.dart';

class NeteasePlaylistSquare extends StatefulWidget {
  @override
  _NeteasePlaylistSquareState createState() => _NeteasePlaylistSquareState();
}

class _NeteasePlaylistSquareState extends State<NeteasePlaylistSquare> with SingleTickerProviderStateMixin {
  
  TabController _tabController;

  List _tabs = ["推荐", "官方", "精品", "华语", "民谣", "轻音乐", "电子", "摇滚"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: "歌单广场",
      ),
      tabbar: TabBar(
        isScrollable: true,
        controller: _tabController,
        tabs: _tabs.map((item) {
          return Tab(
            child: Container(
              width: screenUtil.setWidth(150.0),
              child: Text(
                item, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenUtil.setSp(30.0)
                )
              ),
            ),
          );
        }).toList()
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme.jpeg'
            ),
            fit: BoxFit.cover
          )
        ),
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 130.0,
        child: TabBarView(
          controller: _tabController,
          // children: _tabs.map((item) => Text(item)).toList(),
          children: _tabs.map((item) => new PlaylistRecommend(cat: item)).toList(),
        )
      )
    );
  }
}
