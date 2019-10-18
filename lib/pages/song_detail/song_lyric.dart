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
    scrollController = new ScrollController(initialScrollOffset: 110.0, keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<MusicChangeNotifier>(context);
    
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.only(
          // top: ScreenUtil.getInstance().setHeight(300.0)
        ),
        child: ListView(
          controller: scrollController,
          children: notifier.lyric.map((item) => Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              item['lyric'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.getInstance().setSp(32.0),
                shadows: [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 3.0
                  )
                ]
              )
            ),
          )).toList(),
        ),
      )
    );
  }
}