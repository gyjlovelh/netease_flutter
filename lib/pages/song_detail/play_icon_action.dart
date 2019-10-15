import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player.dart';

class NeteasePlayIconAction extends StatefulWidget {

  final SongModel song;

  NeteasePlayIconAction({@required this.song});

  @override
  _NeteasePlayIconActionState createState() => _NeteasePlayIconActionState();
}

class _NeteasePlayIconActionState extends State<NeteasePlayIconAction> with SingleTickerProviderStateMixin {
  
  NeteaseMusicController controller;

  AudioPlayerState _playerState = AudioPlayerState.COMPLETED;

  String _currentPostion = '00:00';
  double _progressPosition = 0.0;

  @override
  void initState() {
    super.initState();
    controller = NeteaseMusicController.getInstance();
    
    controller.player.onAudioPositionChanged.listen((e) {
      double rix = e.inSeconds / controller.player.duration.inSeconds;
      setState(() {
        _currentPostion = formarSeconds(e.inSeconds);
        _progressPosition = rix * 500.0;
        print('$_currentPostion $_progressPosition');
      });
    });
    controller.player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  String formarSeconds(int seconds) {
    int minute = seconds ~/ 60;
    int second = seconds % 60;

    return ((minute < 10) ? '0$minute' : '$minute') + ':' + ((second < 10) ? '0$second' : '$second');
  }


  Widget actionIconButton(int pointer, { 
    double size, 
    Color color = Colors.black54, 
    @required VoidCallback onPressed
  }) => GestureDetector(
    child: NeteaseIconData(pointer, size: size ?? ScreenUtil.getInstance().setSp(48.0), color: color),
    onTap: onPressed,
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

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
              children: <Widget>[
                Container(
                  width: screenUtil.setWidth(125.0),
                  child: Text(_currentPostion, textAlign: TextAlign.center),
                ),
                Container(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        width: screenUtil.setWidth(500.0),
                        height: screenUtil.setHeight(3.0),
                        decoration: BoxDecoration(
                          color: Colors.grey
                        ),
                      ),
                      Positioned(
                        left: screenUtil.setWidth(0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(screenUtil.setWidth(10.0)),
                          child: Container(
                            width: screenUtil.setWidth(_progressPosition),
                            height: screenUtil.setHeight(3.0),
                            color: Colors.redAccent,
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
                              color: Colors.green
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
                  child: Text(formarSeconds(controller.player.duration.inSeconds), textAlign: TextAlign.center,),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                actionIconButton(0xe61b, onPressed: () {}),
                actionIconButton(0xe605, onPressed: () {}),
                actionIconButton(
                  _playerState == AudioPlayerState.PLAYING ? 0xe6cb : 0xe674, 
                  size: screenUtil.setSp(100.0), 
                  onPressed: () async {
                    if (_playerState != AudioPlayerState.PLAYING) {
                      controller.currentMusicInfo = widget.song;
                      await controller.play();
                    } else {
                      await controller.pause();
                    }
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