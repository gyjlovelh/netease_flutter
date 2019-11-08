import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

class FmActions extends StatefulWidget {
  @override
  _FmActionsState createState() => _FmActionsState();
}

class _FmActionsState extends State<FmActions> {

  Widget actionItem(int pointer, {VoidCallback onPressed}) {

    return GestureDetector(
      onTap: onPressed,
      child: NeteaseIconData(
        pointer,
        color: Colors.white70,
        size: 28.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<PlayerStatusNotifier>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        actionItem(0xe6c1),
        actionItem(0xe616),
        Container(
          width: 56.0,
          height: 100.0,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                height: 56.0,
                width: 56.0,
                child: CircularProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.white70,
                  strokeWidth: 1.5,
                ),
              ),
              actionItem(notifier.playerState == AudioPlayerState.PLAYING ? 0xe636 : 0xe65e, onPressed: () {
                if (notifier.playerState == AudioPlayerState.PLAYING) {
                  notifier.pause();
                } else {
                  notifier.play();
                }
              }),
            ],
          ),
        ),
        actionItem(0xeaad, onPressed: () {
          final provider = Provider.of<PlayerSongDemand>(context);
          provider.next();
        }),
        actionItem(0xe618, onPressed: () {
          final provider = Provider.of<PlayerSongDemand>(context);
          Navigator.of(context).pushNamed('comment', arguments: json.encode({"id": provider.currentMusic.id, "type": "music", "commentCount": 0}));
        }),
      ],
    );
  }
}