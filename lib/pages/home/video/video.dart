import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './video_detail.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> with TickerProviderStateMixin {
  int _videoTypeId = 60100;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: ScreenUtil.instance.setHeight(120.0),
          child: barLists(),
        ),
        Container(
          height: ScreenUtil.instance.setHeight(900.0),
          child: VideoDetail(
            id: _videoTypeId,
          ),
        ),
      ],
    );
  }

  //视频类型导航栏
  Widget barLists() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        barListItem('翻唱', 60100),
        barListItem('舞蹈', 1101),
        barListItem('游戏', 2103),
        barListItem('萌宠', 1103),
        barListItem('现场', 58100),
        barListItem('听BGM', 58101),
        barListItem('生活', 2100),
        barListItem('MV', 1000),
        barListItem('影视', 3100),
        barListItem('ACG音乐', 57104),
      ],
    );
  }

  Widget barListItem(String title, int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _videoTypeId = i;
        });
      },
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Text(
          title,
          style: TextStyle(
            color: i == _videoTypeId ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
