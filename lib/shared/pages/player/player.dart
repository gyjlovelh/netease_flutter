import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeteasePlayer extends StatefulWidget {
  @override
  _NeteasePlayerState createState() => _NeteasePlayerState();
}

class _NeteasePlayerState extends State<NeteasePlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // height: ScreenUtil.getInstance().setHeight(200.0),
            color: Colors.black,
            child: Text('data'),
          )
        ],
      ),
    );
  }
}