import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/pages/song_detail/song_lyric.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:provider/provider.dart';

import 'play_icon_action.dart';
import 'song_cover.dart';

class NeteaseSongDetail extends StatefulWidget {
  @override
  _NeteaseSongDetailState createState() => _NeteaseSongDetailState();
}

class _NeteaseSongDetailState extends State<NeteaseSongDetail> {

  bool showLyric = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    final provider = Provider.of<MusicChangeNotifier>(context);
    SongModel song =  provider.currentMusic;

    print(song);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(song.name, style: TextStyle(
              fontSize: screenUtil.setSp(30.0)
            )),
            Text(song.ar.map((item) => item.name).join(','), style: TextStyle(
              fontSize: screenUtil.setSp(24.0)
            ))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_blur.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            new NeteaseSongCover(song: song),
            // new NeteaseSongLyric(),
            new NeteasePlayIconAction(song: song)
          ],
        ),
      )
    );
  }
}