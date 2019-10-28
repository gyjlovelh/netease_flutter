import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import './icon_buttons_vo.dart';

class IconButtonsItem extends StatelessWidget {
  final IconButtonsVO itemVO;

  IconButtonsItem({@required this.itemVO});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6.0,right: 6.0),
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  bottom: ScreenUtil.getInstance().setHeight(15.0)),
              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(24.0)),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(99.0)),
              child: NeteaseIconData(
                itemVO.pointer,
                color: Colors.white,
                size: ScreenUtil.getInstance().setSp(42.0),
              ),
            ),
            Text(itemVO.label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(24.0)))
          ],
        ),
      ),
    );
  }
}
