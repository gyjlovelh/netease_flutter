import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

class NeteasePlaylistActions extends StatelessWidget {

  final PlaylistModel detail;
  final LoadingStatus status;
  
  NeteasePlaylistActions({@required this.detail, this.status}); 

  Widget actionItem(int pointer, {String label, VoidCallback onPressed}) => FlatButton(
    onPressed: status == LoadingStatus.LOADED ? onPressed : null,
    disabledTextColor: Colors.grey,
    textColor: Colors.white,
    padding: EdgeInsets.symmetric(
      vertical: ScreenUtil.getInstance().setHeight(18.0)
    ),
    child: Column(
      children: <Widget>[
        NeteaseIconData(pointer, size: 20.0),
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(8.0)),
          child: Text(
            "$label",
            style: TextStyle(
              fontSize: SizeSetting.size_12,
              fontWeight: FontWeight.w400
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
          actionItem(0xe618, label: status != LoadingStatus.LOADED ? "评论" : detail.commentCount.toString(), onPressed: () {
            Navigator.of(context).pushNamed('comment', arguments: json.encode({
              "id": detail.id,
              "type": "playlist",
              "commentCount": detail.commentCount
            }).toString());
          }),
          actionItem(0xe624, label: status != LoadingStatus.LOADED ? "分享" : detail.shareCount.toString(), onPressed: () {}),
          actionItem(0xe617, label: '下载'),
          actionItem(0xe618, label: '多选'),
        ],
      ),
    );
  }
}