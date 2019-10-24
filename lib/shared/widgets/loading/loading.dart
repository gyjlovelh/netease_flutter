import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NeteaseLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitWave(
            size: screenUtil.setSp(36.0),
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(screenUtil.setWidth(2.0)),
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10.0
            ),
            child: Text('努力加载中...', style: TextStyle(
              color: Colors.white70,
              fontSize: screenUtil.setSp(28.0)
            )),
          )
        ],
      )
    );
  }
}