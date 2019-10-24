import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:provider/provider.dart';

class NeteaseSongLyric extends StatefulWidget {
  @override
  _NeteaseSongLyricState createState() => _NeteaseSongLyricState();
}

class _NeteaseSongLyricState extends State<NeteaseSongLyric> {

  // 歌词滚动控制
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController(initialScrollOffset: 300.0, keepScrollOffset: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<MusicChangeNotifier>(context);
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    
    return CustomScrollView(
        slivers :<Widget>[
          SliverFixedExtentList(
            itemExtent: screenUtil.setHeight(500.0),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container();
            }, childCount: 1)
          ),
          SliverFixedExtentList(
            itemExtent: 40.0,
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              var item = notifier.lyric[index];

              return Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  item['lyric'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenUtil.setSp(30.0),
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: screenUtil.setWidth(8.0)
                      )
                    ]
                  ),
                ),
              );
            }, childCount: notifier.lyric.length),
          ),
          SliverFixedExtentList(
            itemExtent: screenUtil.setHeight(300.0),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return null;
            }, childCount: 1)
          ),
        ]
      );
  }
}