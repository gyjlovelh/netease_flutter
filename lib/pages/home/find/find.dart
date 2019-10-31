import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/home/find/swiper.dart';

import 'icon_buttons.dart';
import 'recommend_playlist.dart';

class NeteaseFind extends StatefulWidget {
  @override
  _NeteaseFindState createState() => _NeteaseFindState();
}

class _NeteaseFindState extends State<NeteaseFind> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: RefreshIndicator(
        onRefresh: () async {
          print('上拉刷新');
          Future.delayed(Duration(seconds: 2), () {
            print('object');
          });
        },
        displacement: 50.0,
        child: Column(
          children: <Widget>[
            new NeteaseSwiper(),
            new NeteaseIconButtons(),
            Divider(height: screenUtil.setHeight(66.0), color: Theme.of(context).primaryColor,),
            new NeteaseRecommentPlaylist(),
          ],
        ),
      )
    );
  }
}