import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
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
                    title: Text(detail['name']),
                    subtitle: Text(detail['creator']['nickname']),
                  );
                }
                
              }, childCount: 1),
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
  }
}