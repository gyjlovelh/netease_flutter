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

  List tabs = [];

  @override
  void initState() {
    tabs..add({"title": '推荐', "widget": new PlaylistRecommend()})
      ..add({"title": '官方', "widget": Text('data')})
      ..add({"title": '精品', "widget": Text('data')})
      ..add({"title": '华语', "widget": Text('data')})

      ..add({"title": '民谣', "widget": Text('data')})
      ..add({"title": '轻音乐', "widget": Text('data')})
      ..add({"title": '电子', "widget": Text('data')})
      ..add({"title": '摇滚', "widget": Text('data')});

    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);
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
          
          tabs: tabs.map((tab) => Tab(
            child: Container(
              width: screenUtil.setWidth(150.0),
              child: Text(
                tab['title'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenUtil.setSp(30.0)
                )
              ),
            ),
          )).toList(),
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
                  children: <Widget>[
                    new PlaylistRecommend(),
                    Tab(text: '华语',),
                    Tab(text: '民谣',),
                    Tab(text: '轻音乐',),
                    Tab(text: '电子',),
                    Tab(text: '电子',),
                    Tab(text: '电子',),
                    Tab(text: '电子',)
                  ],
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
