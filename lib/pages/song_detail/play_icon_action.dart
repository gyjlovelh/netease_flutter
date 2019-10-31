import 'dart:async';
import 'dart:math';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
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

  String formarSeconds(int seconds) {
    if (seconds == null || seconds.isNaN) {
      return '00:00';
    }
    int minute = seconds ~/ 60;
    int second = seconds % 60;

    return ((minute < 10) ? '0$minute' : '$minute') + ':' + ((second < 10) ? '0$second' : '$second');
  }

  double progress(int c, int t) {
    if (c != null && t != null && t != 0) {
      return c / t * 500.0;
    } else {
      return 0.0;
    }
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
    final provider = Provider.of<PlayerStatusNotifier>(context);

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
                    formarSeconds(provider.current), 
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
                    max: provider.duration.toDouble() ?? 100,
                    value: _isPointerDown ? _sliderValue : provider.current.toDouble(),
                    onChanged: (double v) => setState(() => _sliderValue = v),
                    onChangeStart: (double v) => setState(() => _isPointerDown = true),
                    onChangeEnd: (double v) {      
                      // 防止圆点抖动
                      Timer(Duration(milliseconds: 100), () {
                        _isPointerDown = false;
                      });
                      setState(() {
                        _sliderValue = v;
                        provider.audioPlayer.seek(v);
                      });
                    },
                  ),
                ),
                Container(
                  width: screenUtil.setWidth(125.0),
                  child: Text(
                    formarSeconds(provider.duration), 
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
                  provider.repeatMode == RepeatMode.LIST ? 0xe63e : 
                  provider.repeatMode == RepeatMode.RANDOM ? 0xe61b : 0xe640, 
                  onPressed: () {
                    provider.changeRepeatMode();  
                    String message = '';
                    if (provider.repeatMode == RepeatMode.SINGLE) {
                      message = "单曲循环";
                    } else if (provider.repeatMode == RepeatMode.LIST) {
                      message = "列表循环";
                    } else if (provider.repeatMode == RepeatMode.RANDOM) {
                      message = "随机播放";
                    }
                    Toast.show('$message', context, duration: 2);
                  }
                ),
                actionIconButton(0xe605, onPressed: provider.prev),
                actionIconButton(
                  provider.playerState == AudioPlayerState.PLAYING ? 0xe6cb : 0xe674, 
                  size: screenUtil.setSp(100.0), 
                  onPressed: () async {
                    if (provider.playerState == AudioPlayerState.PLAYING) {
                      provider.pause();
                    } else {
                      provider.play();
                    }
                  }
                ),
                actionIconButton(0xeaad, onPressed: provider.next),
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