import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/lyric/lyric.dart';
import 'package:provider/provider.dart';

import 'play_icon_action.dart';
import 'song_cover.dart';

class NeteaseSongDetail extends StatefulWidget {
  @override
  _NeteaseSongDetailState createState() => _NeteaseSongDetailState();
}

class _NeteaseSongDetailState extends State<NeteaseSongDetail> {

  bool showLyric = false;

  Widget showMain() {
    if (showLyric) {
      return new NeteaseLyric();
    } else {
      return new NeteaseSongCover();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Consumer<PlayerSongDemand>(builder: (BuildContext context, notifier, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${notifier.currentMusic.name}", style: TextStyle(
                fontSize: SizeSetting.size_16
              )),
              Text(
                "${(notifier.currentMusic.ar ?? notifier.currentMusic.artists).map((item) => item.name).join(',')}",
                style: TextStyle(
                  fontSize: SizeSetting.size_12
                ),
              )
            ],
          );
        }),
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
                  child: showMain(),
                ),
              ),
              new NeteasePlayIconAction()
            ],
          ),
        ),
      )
    );
  }
}