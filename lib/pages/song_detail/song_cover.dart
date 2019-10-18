import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

class NeteaseSongCover extends StatefulWidget {

  final SongModel song;

  NeteaseSongCover({@required this.song});

  @override
  _NeteaseSongCoverState createState() => _NeteaseSongCoverState();
}

class _NeteaseSongCoverState extends State<NeteaseSongCover> with SingleTickerProviderStateMixin {
  AnimationController controller;
  StreamSubscription subscription;

  Widget iconButton(int pointer) => GestureDetector(
    child: Container(
      decoration: BoxDecoration(

      ),
      child: NeteaseIconData(
        pointer,
        color: Colors.white60,
        size: ScreenUtil.getInstance().setSp(48.0),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 25), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<MusicPlayerStatus>(context);
    AudioPlayer player = provider.audioPlayer;

    subscription = player.onPlayerStateChanged.listen((AudioPlayerState state) {
      if (state == AudioPlayerState.PLAYING) {
        controller.forward();
      } else {
        controller.stop();
      }
    });
    
    if (provider.playerState == AudioPlayerState.PLAYING) {
      controller.forward();
    }

    return Expanded(
      flex: 1,
      // child: Container(
      //   color: Colors.cyanAccent,
      // ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(screenUtil.setWidth(30.0)),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: screenUtil.setWidth(4.0),
                      color: Colors.white54
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white12,
                        blurRadius: screenUtil.setWidth(25.0),
                        spreadRadius: screenUtil.setWidth(18.0)
                      )
                    ],
                    borderRadius: BorderRadius.circular(999.0)
                  ),
                  child: RotationTransition(
                    turns: controller,
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Image.network(
                        widget.song.al.picUrl,
                        fit: BoxFit.cover,
                        width: screenUtil.setWidth(480.0),
                        height: screenUtil.setWidth(480.0),
                      ),
                    ),
                  )
                )
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              height: screenUtil.setHeight(110.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  iconButton(0xe616),
                  iconButton(0xe617),
                  iconButton(0xe612),
                  iconButton(0xe618),
                  iconButton(0xe66f),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}