import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/comment_arguments.dart';

class NeteaseComment extends StatefulWidget {

  @override
  _NeteaseCommentState createState() => _NeteaseCommentState();
}

class _NeteaseCommentState extends State<NeteaseComment> {
  @override
  Widget build(BuildContext context) {
    CommentArguments arguments = CommentArguments.fromJson(json.decode(ModalRoute.of(context).settings.arguments));

    return Scaffold(
      appBar: AppBar(
        title: Text('评论(${arguments.commentCount})'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomScrollView(
              slivers: <Widget>[
                
              ],
            )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: ScreenUtil.bottomBarHeight,
            height: 50.0,
            child: Container(
              color: Colors.tealAccent.withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}