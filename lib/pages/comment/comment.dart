import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/comment.dart';
import 'package:netease_flutter/models/comment_arguments.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteaseComment extends StatefulWidget {

  @override
  _NeteaseCommentState createState() => _NeteaseCommentState();
}

class _NeteaseCommentState extends State<NeteaseComment> {
  CommentArguments arguments;
  Map<String, dynamic> detail;
  LoadingStatus status = LoadingStatus.UNINIT;

  // 热门评论
  List _hotComments = [];
  List _comments = [];

  @override
  void initState() {
    super.initState();
  }

  Widget publishDate(CommentModel comment) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    DateTime time = DateTime(comment.time);
    String timeStamp = "${time.month}月${time.day}日";
    return 
    Text(
      "$timeStamp",
      style: TextStyle(
        color: Colors.white54,
        fontSize: screenUtil.setSp(20.0)
      ),
    );
  }

  Widget likeBtn(CommentModel comment) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return GestureDetector(
      child: Container(
        width: screenUtil.setWidth(110.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.ac_unit, size: screenUtil.setSp(30.0), color: Colors.white60,),
            Text(
              "${comment.likedCount}",
              style: TextStyle(
                color: Colors.white60
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    arguments = CommentArguments.fromJson(json.decode(ModalRoute.of(context).settings.arguments));
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (status == LoadingStatus.UNINIT) {
      _loadTargetDetail();
      _loadCommentMore();
    }

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: '评论(${arguments.commentCount})',
      ),
      body: Container(
        height: 400.0,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFixedExtentList(
              itemExtent: screenUtil.setHeight(250.0),
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                if (detail == null) {
                  return Container();
                } else {
                  return ListTile(
                    leading: Container(
                      height: screenUtil.setHeight(200.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenUtil.setWidth(12.0)),
                        child: Image.network(
                          detail['coverImgUrl'],
                          height: screenUtil.setHeight(200.0),
                          width: screenUtil.setWidth(200.0),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    dense: true,
                    title: Text(detail['name'], style: TextStyle(
                      color: Colors.white
                    )),
                    subtitle: Text(arguments.id.toString()),
                    // subtitle: Text(detail['creator']['nickname'], style: TextStyle(
                    //   color: Colors.white70
                    // )),
                  );
                }
              }, childCount: 1),
            ),
            SliverFixedExtentList(
              itemExtent: screenUtil.setWidth(250.0),
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                CommentModel comment = CommentModel.fromJson(_hotComments[index]);
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      comment.user.avatarUrl, 
                      fit: BoxFit.cover,
                      height: screenUtil.setWidth(65.0),
                      width: screenUtil.setWidth(65.0),
                    ),
                  ),
                  title: Container(
                    height: screenUtil.setHeight(70.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(comment.user.nickname, style: TextStyle(
                          color: Colors.white,
                          fontSize: screenUtil.setSp(24.0)
                        )),
                        publishDate(comment)
                      ],
                    ),
                  ),
                  subtitle: Text(
                    comment.content, 
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white70
                    )
                  ),
                  trailing: likeBtn(comment)
                );
              }, childCount: _hotComments.length),
            )
          ],
        ),
      ),
      customFooter: Container(
        color: Colors.tealAccent,
      ),
    );
  }

  void _loadTargetDetail() async {
    
    final result = await RequestService.getInstance(context: context).getPlaylistDetail(arguments.id);

    setState(() {
      status = LoadingStatus.LOADED;
      detail = result.toJson();
    });
  }

  void _loadCommentMore() async {
    final result = await RequestService.getInstance(context: context).getComments(
      type: arguments.type,
      id: arguments.id,
      limit: 20
    );

    print(result);
    
    setState(() {
      _hotComments.addAll(result['hotComments']);
      _comments.addAll(result['comments']);
    });

  }
}