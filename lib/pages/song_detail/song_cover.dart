import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';

class NeteaseSongCover extends StatefulWidget {

  final SongModel song;

  NeteaseSongCover({@required this.song});

  @override
  _NeteaseSongCoverState createState() => _NeteaseSongCoverState();
}

class _NeteaseSongCoverState extends State<NeteaseSongCover> {

  Widget iconButton(int pointer) => GestureDetector(
    child: Container(
      decoration: BoxDecoration(

      ),
      child: NeteaseIconData(
        pointer,
        color: Colors.grey,
        size: ScreenUtil.getInstance().setSp(48.0),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

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
                      width: screenUtil.setWidth(8.0),
                      color: Colors.grey[300]
                    ),
                    borderRadius: BorderRadius.circular(999.0)
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.song.al.picUrl,
                      fit: BoxFit.cover,
                      width: screenUtil.setWidth(480.0),
                      height: screenUtil.setWidth(480.0),
                    ),
                  ),
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