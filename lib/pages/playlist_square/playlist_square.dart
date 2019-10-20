import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/player/player.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('歌单广场'),
        backgroundColor: Colors.black38,
        bottom: TabBar(
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
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((item) => new PlaylistRecommend(cat: item)).toList(),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                height: screenUtil.setHeight(Global.PLAYER_SCALE * screenUtil.height),
                child: new NeteasePlayer(),
              ),
            )
          ],
        ),
      )
    );
  }
}
