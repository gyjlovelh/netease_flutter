import 'dart:async';
import 'dart:math';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/event/event.dart';
import 'package:netease_flutter/shared/player/player_position.dart';
import 'package:netease_flutter/shared/player/player_repeat_mode.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NeteasePlayIconAction extends StatefulWidget {

  final SongModel song;

  NeteasePlayIconAction({@required this.song});

  @override
  _NeteasePlayIconActionState createState() => _NeteasePlayIconActionState();
}

class _NeteasePlayIconActionState extends State<NeteasePlayIconAction> with SingleTickerProviderStateMixin {
  
  bool _isPointerDown = false;
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    final statusProvider = Provider.of<PlayerStatusNotifier>(context);
    final repeatModeProvider = Provider.of<PlayerRepeatMode>(context);
    final positionProvider = Provider.of<PlayerPosition>(context);

    return Expanded(
      flex: 0,
      child: Container(
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
                    max: positionProvider.duration.inSeconds.toDouble(),
                    value: _isPointerDown ? _sliderValue : min(positionProvider.current.inSeconds.toDouble(), positionProvider.duration.inSeconds.toDouble()),
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                actionIconButton(
                  repeatModeProvider.repeatMode == RepeatMode.LIST ? 0xe63e : 
                  repeatModeProvider.repeatMode == RepeatMode.RANDOM ? 0xe61b : 0xe640, 
                  onPressed: () {
                    repeatModeProvider.changeRepeatMode();  
                    String message = '';
                    if (repeatModeProvider.repeatMode == RepeatMode.SINGLE) {
                      message = "单曲循环";
                    } else if (repeatModeProvider.repeatMode == RepeatMode.LIST) {
                      message = "列表循环";
                    } else if (repeatModeProvider.repeatMode == RepeatMode.RANDOM) {
                      message = "随机播放";
                    }
                    Toast.show('$message', context, duration: 2);
                  }
                ),
                actionIconButton(0xe605, onPressed: _prev),
                actionIconButton(
                  statusProvider.playerState == AudioPlayerState.PLAYING ? 0xe6cb : 0xe674, 
                  size: screenUtil.setSp(100.0), 
                  onPressed: () async {
                    if (statusProvider.playerState == AudioPlayerState.PLAYING) {
                      statusProvider.pause();
                    } else {
                      statusProvider.play(context: context);
                    }
                  }
                ),
                actionIconButton(0xeaad, onPressed: _next),
                actionIconButton(0xe604, onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return new NeteaseMusicList();
                    }
                  );   
                })
              ],
            )
          ],
        ),
      ),
    );    
  }

  void _prev() {
    final statusProvider = Provider.of<PlayerStatusNotifier>(context);
    statusProvider.prev(context: context);
  }

  void _next() {
    final statusProvider = Provider.of<PlayerStatusNotifier>(context);
    statusProvider.next(context: context);
  }
}