import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/comment_arguments.dart';
import 'package:netease_flutter/shared/event/event.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

class NeteaseSongCover extends StatefulWidget {

  NeteaseSongCover();

  @override
  _NeteaseSongCoverState createState() => _NeteaseSongCoverState();
}

class _NeteaseSongCoverState extends State<NeteaseSongCover> with SingleTickerProviderStateMixin {
  AnimationController controller;

  Widget iconButton(int pointer, {VoidCallback onPressed}) => IconButton(
    icon: NeteaseIconData(
      pointer,
      color: Colors.white60,
      size: ScreenUtil.getInstance().setSp(48.0),
    ),
    onPressed: onPressed,
  );

  @override
  void initState() {
    super.initState();
    NeteaseEvent event = NeteaseEvent.getInstance();
    event.subscribe('netease.player.state.change', _whenPlayerStateChange);
    controller = AnimationController(duration: Duration(seconds: 25), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
      }
    });

    if (Global.player.state == AudioPlayerState.PLAYING) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    NeteaseEvent event = NeteaseEvent.getInstance();
    event.unsubscribe('netease.player.state.change', _whenPlayerStateChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    double startX = 0.0;
    double endX = 0.0;
    double startY = 0.0;
    double endY = 0.0;
    
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: Center(
              child: GestureDetector(
                onHorizontalDragStart: (DragStartDetails details) {
                  startX = details.globalPosition.dx;
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  endX = details.globalPosition.dx;
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  if ((startX - endX).abs() >= 50.0) {
                    if (startX > endX) {
                      Provider.of<PlayerSongDemand>(context, listen: false).next();
                    } else {
                      Provider.of<PlayerSongDemand>(context, listen: false).prev();
                    }
                  }
                },
                onVerticalDragStart: (DragStartDetails details) {
                  startY = details.globalPosition.dy;
                },
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  endY = details.globalPosition.dy;
                },
                onVerticalDragEnd: (DragEndDetails details) {
                  if ((startY - endX).abs() >= 50) {
                    if (startY > endY) {
                      CommentArguments arguments = CommentArguments(id: Provider.of<PlayerSongDemand>(context, listen: false).currentMusic.id, type: 'music', commentCount: 0);
                      Navigator.of(context).pushNamed('comment', arguments: json.encode(arguments.toJson()));
                    }
                  }
                },
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
                  child: Consumer<PlayerSongDemand>(
                    builder: (context, notifier, _) {
                      return RotationTransition(
                        turns: controller,
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Image.network(
                            "${(notifier.currentMusic.al ?? notifier.currentMusic.album).picUrl}",
                            fit: BoxFit.cover,
                            width: screenUtil.setWidth(480.0),
                            height: screenUtil.setWidth(480.0),
                          ),
                        ),
                      );
                    },
                  )
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
                iconButton(0xe612,),
                iconButton(0xe618, onPressed: () {
                  Navigator.of(context).pushNamed('comment', arguments: json.encode({
                    "id": Provider.of<PlayerSongDemand>(context, listen: false).currentMusic.id,
                    "commentCount": 0
                  }));
                }),
                iconButton(0xe66f),
              ],
            ),
          ),
        )
      ]
    );
  }

  // 当播放状态发生变化时
  void _whenPlayerStateChange(var state) {
    if (controller == null) {
      return;
    }
    if (state == AudioPlayerState.PLAYING) {
      controller.forward();
    } else {
      controller.stop();
    }
  }
}