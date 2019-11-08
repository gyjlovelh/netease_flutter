import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/player_position.dart';
import 'package:netease_flutter/shared/player/player_repeat_mode.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NeteasePlayIconAction extends StatefulWidget {

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
    Color color = Colors.white70, 
    @required VoidCallback onPressed
  }) => GestureDetector(
    child: NeteaseIconData(pointer, size: size ?? 24, color: color),
    onTap: onPressed,
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    return Expanded(
      flex: 0,
      child: Container(
        height: screenUtil.setHeight(240.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<PlayerPosition>(
              builder: (context, notifier, _) {
                double maxValue = max(notifier.duration.inSeconds, 0).toDouble();
                double currentValue = min(max(notifier.current.inSeconds, 0).toDouble(), maxValue);
                return  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenUtil.setWidth(125.0),
                      child: Text(
                        "${notifier.currentTime}", 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeSetting.size_10
                        ),
                      ),
                    ),
                    Container(
                      width: screenUtil.setWidth(500.0),
                      child: Slider(
                        min: 0,
                        max: maxValue,
                        value: _isPointerDown ? _sliderValue : currentValue,
                        onChanged: (double v) => setState(() => _sliderValue = v),
                        onChangeStart: (double v) => setState(() => _isPointerDown = true),
                        onChangeEnd: (double v) {      
                          // 防止圆点抖动
                          Timer(Duration(milliseconds: 100), () {
                            _isPointerDown = false;
                          });
                          setState(() {
                            _sliderValue = v;
                            Global.player.seek(new Duration(seconds: v.toInt()));
                          });
                        },
                      ),
                    ),
                    Container(
                      width: screenUtil.setWidth(125.0),
                      child: Text(
                        "${notifier.durationTime}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeSetting.size_10
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Consumer<PlayerRepeatMode>(
                  builder: (context, notifier, _) => actionIconButton(
                    notifier.repeatMode == RepeatMode.LIST ? 0xe63e : 
                    notifier.repeatMode == RepeatMode.RANDOM ? 0xe61b : 0xe640, 
                    onPressed: () {
                      notifier.changeRepeatMode();  
                      String message = '';
                      if (notifier.repeatMode == RepeatMode.SINGLE) {
                        message = "单曲循环";
                      } else if (notifier.repeatMode == RepeatMode.LIST) {
                        message = "列表循环";
                      } else if (notifier.repeatMode == RepeatMode.RANDOM) {
                        message = "随机播放";
                      }
                      Toast.show('$message', context, duration: 2);
                    }
                  ),
                ),
                actionIconButton(0xe605, onPressed: () => Provider.of<PlayerSongDemand>(context, listen: false).prev()),
                Consumer<PlayerStatusNotifier>(
                  builder: (context, notifier, _) => Container(
                    width: 50.0,
                    height: 50.0,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          height: 50.0,
                          width: 50.0,
                          child: CircularProgressIndicator(
                            value: 0.0,
                            backgroundColor: Colors.white70,
                            strokeWidth: 1.5,
                          ),
                        ),
                        actionIconButton(notifier.playerState == AudioPlayerState.PLAYING ? 0xe636 : 0xe65e, onPressed: () {
                          if (notifier.playerState == AudioPlayerState.PLAYING) {
                            notifier.pause();
                          } else {
                            notifier.play();
                          }
                        }),
                      ],
                    ),
                  ),
                ),
                actionIconButton(0xeaad, onPressed: () => Provider.of<PlayerSongDemand>(context, listen: false).next()),
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
}