import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './video_detail.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<int> _videoTypeIds = [
    60100,
    1101,
    2103,
    1103,
    58100,
    58101,
    2100,
    1000,
    3100,
    57104
  ];
  // List<VideoDetail> _videoDetails = List<VideoDetail>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0),
          height: ScreenUtil.instance.setHeight(80.0),
          child: barLists(),
        ),
        Container(
          height: ScreenUtil.instance.setHeight(960.0),
          child: Container(
            child: VideoDetail(
              id: _videoTypeIds[_currentIndex],
            ),
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
        barListItem('翻唱', 0),
        barListItem('舞蹈', 1),
        barListItem('游戏', 2),
        barListItem('萌宠', 3),
        barListItem('现场', 4),
        barListItem('听BGM', 5),
        barListItem('生活', 6),
        barListItem('MV', 7),
        barListItem('影视', 8),
        barListItem('ACG音乐', 9),
      ],
    );
  }

  Widget barListItem(String title, int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = i;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text(
          title,
          style: TextStyle(
            color: i == _currentIndex ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}
