import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

class NeteasePlaylistActions extends StatelessWidget {

  final PlaylistModel detail;
  
  NeteasePlaylistActions({@required this.detail}); 

  Widget actionItem(int pointer, {String label, VoidCallback onPressed}) => FlatButton(
    onPressed: onPressed,
    child: Column(
      children: <Widget>[
        NeteaseIconData(pointer, color: Colors.white, size: ScreenUtil.getInstance().setSp(42.0)),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(8.0)),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(24.0)
            ),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          actionItem(0xe618, label: detail.commentCount.toString()),
          actionItem(0xe624, label: detail.shareCount.toString()),
          actionItem(0xe617, label: '下载'),
          actionItem(0xe618, label: '多选'),
        ],
      ),
    );
  }
}