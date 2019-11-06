import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';

class FmCover extends StatefulWidget {
  final SongModel song;
  FmCover({this.song});

  @override
  _FmCoverState createState() => _FmCoverState();
}

class _FmCoverState extends State<FmCover> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Column(
      children: <Widget>[
        Container(
          height: screenUtil.setWidth(650),
          width: screenUtil.setWidth(650),
          margin: EdgeInsets.symmetric(
            vertical: screenUtil.setHeight(35.0)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0)),
            child: Image.network(
              "${widget.song?.album?.picUrl}",
              height: screenUtil.setWidth(680),
              width: screenUtil.setWidth(680),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenUtil.setWidth(50.0),
          ),
          child: Text(
            "${widget.song?.name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(42.0)
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenUtil.setWidth(50.0),
              vertical: screenUtil.setHeight(15.0)
            ),
            child: Text(
              "${(widget.song?.artists ?? []).map((item) => item.name).join(',')} >",
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenUtil.setSp(28.0)
              ),
            ),
          )
        )
      ],
    );
  }
}