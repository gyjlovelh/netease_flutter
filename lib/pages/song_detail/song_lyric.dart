import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:provider/provider.dart';

class NeteaseSongLyric extends StatefulWidget {
  @override
  _NeteaseSongLyricState createState() => _NeteaseSongLyricState();
}

class _NeteaseSongLyricState extends State<NeteaseSongLyric> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<MusicChangeNotifier>(context);

    print(notifier.lyric);
    
    return Expanded(
      flex: 1,
      child: ListView(
        children: notifier.lyric.map((item) => Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            item['time'] +item['lyric'],
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
    );
  }
}