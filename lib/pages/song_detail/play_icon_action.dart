import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:provider/provider.dart';

class NeteasePlayIconAction extends StatefulWidget {

  final SongModel song;

  NeteasePlayIconAction({@required this.song});

  @override
  _NeteasePlayIconActionState createState() => _NeteasePlayIconActionState();
}

class _NeteasePlayIconActionState extends State<NeteasePlayIconAction> with SingleTickerProviderStateMixin {
  
  AudioPlayerState _playerState = AudioPlayerState.COMPLETED;

  String _currentPostion = '00:00';
  double _progressPosition = 0.0;

  @override
  void initState() {
    super.initState();
  }

  String formarSeconds(int seconds) {
    int minute = seconds ~/ 60;
    int second = seconds % 60;

    return ((minute < 10) ? '0$minute' : '$minute') + ':' + ((second < 10) ? '0$second' : '$second');
  }


  Widget actionIconButton(int pointer, { 
    double size, 
    Color color = Colors.white, 
    @required VoidCallback onPressed
  }) => GestureDetector(
    child: NeteaseIconData(pointer, size: size ?? ScreenUtil.getInstance().setSp(48.0), color: color),
    onTap: onPressed,
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final stateController = Provider.of<MusicPlayerStatus>(context);

    return Expanded(
      flex: 0,
      child: Container(
        // color: Colors.deepOrange,
        height: screenUtil.setHeight(240.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: screenUtil.setWidth(125.0),
                  child: Text(
                    _currentPostion, 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenUtil.setSp(24.0)
                    ),
                  ),
                ),
                Container(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        width: screenUtil.setWidth(500.0),
                        height: screenUtil.setHeight(3.0),
                        decoration: BoxDecoration(
                          color: Colors.white30
                        ),
                      ),
                      Positioned(
                        left: screenUtil.setWidth(0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(screenUtil.setWidth(10.0)),
                          child: Container(
                            width: screenUtil.setWidth(_progressPosition),
                            height: screenUtil.setHeight(3.0),
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenUtil.setWidth(_progressPosition - 3),
                        top: screenUtil.setHeight(-7.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99.0),
                              color: Colors.white
                            ),
                            width: screenUtil.setWidth(17.0),
                            height: screenUtil.setWidth(17.0)
                          ),
                        )
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenUtil.setWidth(125.0),
                  child: Text(
                    '11:11', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenUtil.setSp(24.0)
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                actionIconButton(
                  stateController.repeatMode == RepeatMode.LIST ? 0xe63e : 
                  stateController.repeatMode == RepeatMode.RANDOM ? 0xe61b : 0xe640, 
                  onPressed: () {
                    stateController.changeRepeatMode();
                  }
                ),
                actionIconButton(0xe605, onPressed: () {}),
                actionIconButton(
                  _playerState == AudioPlayerState.PLAYING ? 0xe6cb : 0xe674, 
                  size: screenUtil.setSp(100.0), 
                  onPressed: () async {
                    
                  }
                ),
                actionIconButton(0xeaad, onPressed: () {}),
                actionIconButton(0xe604, onPressed: () {})
              ],
            )
          ],
        ),
      ),
    );    
  }
}