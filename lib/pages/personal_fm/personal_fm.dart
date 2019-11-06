import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_position.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/lyric/lyric.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';
import 'package:provider/provider.dart';

import 'fm_actions.dart';
import 'fm_cover.dart';

class NeteasePersonalFm extends StatefulWidget {
  @override
  _NeteasePersonalFmState createState() => _NeteasePersonalFmState();
}

class _NeteasePersonalFmState extends State<NeteasePersonalFm> {

  List<SongModel> list = Global.getFmList() ?? [];
  bool _isPointerDown = false;
  double _sliderValue = 0;
  bool showLyric = false;

  //歌词/封面切换
  Widget showMain(SongModel song) {
    if (showLyric) {
      return new NeteaseLyric();
    } else {
      return new FmCover(song: song);
    }
  }

  //播放进度条
  Widget progress() {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final positionProvider = Provider.of<PlayerPosition>(context);
    double duration = max<int>(positionProvider.duration.inSeconds, 0).toDouble();

    return Row(
      children: <Widget>[
        Container(
          width: screenUtil.setWidth(125.0),
          child: Text(
            "${positionProvider.currentTime}", 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenUtil.setSp(24.0)
            ),
          ),
        ),
        Container(
          width: screenUtil.setWidth(500.0),
          child: Slider(
            min: 0,
            max: duration,
            value: _isPointerDown ? _sliderValue : min(positionProvider.current.inSeconds.toDouble(), duration),
            onChanged: (double v) => setState(() => _sliderValue = v),
            onChangeStart: (double v) => setState(() => _isPointerDown = true),
            onChangeEnd: (double v) {      
              // 防止圆点抖动
              Timer(Duration(milliseconds: 100), () {
                _isPointerDown = false;
              });
              setState(() {
                _sliderValue = v;
                Global.player.seek(v);
              });
            },
          ),
        ),
        Container(
          width: screenUtil.setWidth(125.0),
          child: Text(
            "${positionProvider.durationTime}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenUtil.setSp(24.0)
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    
    SongModel song = demandProvider.currentMusic;

    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidthDp,
        height: ScreenUtil.screenHeightDp,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/lyric_bg.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              height: ScreenUtil.statusBarHeight,
              color: Theme.of(context).primaryColor,
            ),
            NeteaseAppBar(
              title: '私人FM',
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5)
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showLyric = !showLyric;
                },
                child: showMain(song),
              ),
            ),
            // 进度条
            Container(
              height: 50.0,
              child: progress(),
            ),
            Expanded(
              flex: 0,
              child: Container(
                height: 100.0,
                child: new FmActions(),
              ),
            )
          ],
        ),
      ),
    );
  }
}