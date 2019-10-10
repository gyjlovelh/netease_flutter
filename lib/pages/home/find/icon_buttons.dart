import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';

class NeteaseIconButtons extends StatelessWidget {

  Widget iconButtonItem(int pointer, {String label}) => Container(

    child: GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(15.0)),
            padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(25.0)),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(99.0)
            ),
            child: NeteaseIconData(pointer, color: Colors.white,),
          ),
          Text(label, style: TextStyle(
            color: Colors.black87,
            fontSize: ScreenUtil.getInstance().setSp(26.0)
          ))
        ],
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          iconButtonItem(0xe652, label: '每日推荐'),
          iconButtonItem(0xe60d, label: '歌单'),
          iconButtonItem(0xe6ab, label: '排行榜'),
          iconButtonItem(0xe608, label: '电台'),
          iconButtonItem(0xe61d, label: '直播')
        ],
      ),
    );
  }
}