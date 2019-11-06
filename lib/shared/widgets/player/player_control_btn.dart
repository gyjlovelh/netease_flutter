import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/player/player_position.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

class PlayerControlBtn extends StatefulWidget {
  @override
  _PlayerControlBtnState createState() => _PlayerControlBtnState();
}

class _PlayerControlBtnState extends State<PlayerControlBtn> {

  int iconPointer(AudioPlayerState state) {
    if (state == AudioPlayerState.PLAYING) {
      return 0xe636;
    } else {
      return 0xe65e;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<PlayerStatusNotifier>(context);
    final positionProvider = Provider.of<PlayerPosition>(context);

    return GestureDetector(
      onTap: () {
        if (provider.playerState != AudioPlayerState.PLAYING) {
          provider.play();
        } else {
          provider.pause();
        }
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                value: positionProvider.progress ?? 0.0,
                backgroundColor: Colors.white70,
                strokeWidth: screenUtil.setWidth(2.0),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: NeteaseIconData(
                iconPointer(provider.playerState),
                size: 18.0,
                color: Colors.white70,
              ),
            )
          ],
        )
      ),
    );
  }
}