import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/pages/song_detail/song_lyric.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:provider/provider.dart';

import 'play_icon_action.dart';
import 'song_cover.dart';

class NeteaseSongDetail extends StatefulWidget {
  @override
  _NeteaseSongDetailState createState() => _NeteaseSongDetailState();
}

class _NeteaseSongDetailState extends State<NeteaseSongDetail> {

  bool showLyric = false;

  Widget showMain(SongModel song) {
    if (showLyric) {
      return new NeteaseSongLyric();
    } else {
      return new NeteaseSongCover(song: song);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    final demandProvider = Provider.of<PlayerSongDemand>(context);
    SongModel song =  demandProvider.currentMusic;
    print('song_detail build..${song.id}');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(song.name, style: TextStyle(
              fontSize: screenUtil.setSp(30.0)
            )),
            Text((song.ar ?? song.artists).map((item) => item.name).join(','), style: TextStyle(
              fontSize: screenUtil.setSp(24.0)
            ))
          ],
        )
      ),
      body: Container(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/lyric_bg.jpg'),
              fit: BoxFit.cover
            )
          ),
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showLyric = !showLyric;
                    });
                  },
                  // child: Text('data'),
                  child: showMain(song),
                ),
              ),
              new NeteasePlayIconAction(song: song)
            ],
          ),
        ),
      )
    );
  }
}