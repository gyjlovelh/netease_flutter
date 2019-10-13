import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';

class NeteasePlayIconAction extends StatefulWidget {

  final SongModel song;

  NeteasePlayIconAction({@required this.song});

  @override
  _NeteasePlayIconActionState createState() => _NeteasePlayIconActionState();
}

class _NeteasePlayIconActionState extends State<NeteasePlayIconAction> {
  
  final AudioPlayer player = new AudioPlayer();

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
                  child: Text('00:00', textAlign: TextAlign.center),
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
                            width: screenUtil.setWidth(200.0),
                            height: screenUtil.setHeight(3.0),
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenUtil.setWidth(192.0),
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
                  child: Text('03:42', textAlign: TextAlign.center,),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                actionIconButton(0xe61b, onPressed: () {}),
                actionIconButton(0xe605, onPressed: () {}),
                actionIconButton(0xe674, size: screenUtil.setSp(100.0), onPressed: () async {
                  await player.play('http://m7.music.126.net/20191012213317/65122b9a612a5fab312c2039b41ab0a3/ymusic/045e/535d/535c/34209bebc5d76c572296d6e60674d6a7.flac');
                  print('played...');
                }),
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