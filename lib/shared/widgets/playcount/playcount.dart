import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

class NeteasePlaycount extends StatelessWidget {

  final int playCount;
  NeteasePlaycount({@required this.playCount});

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    String _playCountStr;

    if (this.playCount > 100000000) {
      double count = (this.playCount ~/ 10000000 / 10);
      _playCountStr = '$count亿';
    } else if (this.playCount > 10000) {
      int count = this.playCount ~/ 10000;
      _playCountStr = '$count万';
    } else {
      _playCountStr = '$playCount';
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenUtil.setWidth(4.0),
          right: screenUtil.setWidth(6.0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: screenUtil.setWidth(5.0)
              ),
              child: NeteaseIconData(
                0xe65e,
                color: Colors.white,
                size: SizeSetting.size_10,
              ),
            ),
            Text(
              _playCountStr,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeSetting.size_10,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: screenUtil.setWidth(8.0)
                  )
                ]
              )
            ),
          ],
        )
      )
    );
  }
}