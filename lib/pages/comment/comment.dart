import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/comment.dart';
import 'package:netease_flutter/models/comment_arguments.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
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

  bool _moreHotComment = true;
  bool _moreComment = true;
  int _lastItemTime;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_comments.isNotEmpty) {
          _lastItemTime = _comments.last['time'];
        }
        _loadCommentMore();        
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      onTap: () {},
      child: Container(
        width: screenUtil.setWidth(150.0),
        padding: EdgeInsets.only(
          right: screenUtil.setWidth(30.0)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: screenUtil.setHeight(3.0),
                right: screenUtil.setWidth(8.0)
              ),
              child: Text(
                "${comment.likedCount}",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: screenUtil.setSp(24.0)
                ),
              ),
            ),
            NeteaseIconData(
              0xe631,
              color: Colors.white60,
              size: screenUtil.setSp(32.0),
            )
          ],
        ),
      ),
    );
  }

  Widget listTitle(String title) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SliverFixedExtentList(
      itemExtent: screenUtil.setHeight(70.0),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(
            top: screenUtil.setHeight(30.0)
          ),
          padding: EdgeInsets.only(
            left: screenUtil.setWidth(30.0)
          ),
          child: Text(
            '$title',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(26.0),
              fontWeight: FontWeight.bold
            ),
          ),
        );
      }, childCount: 1),
    );
  }

  Widget commentList(List list) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        CommentModel comment = CommentModel.fromJson(list[index]);
        return GestureDetector(
          child: Container(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    padding: EdgeInsets.all(screenUtil.setWidth(30.0)),
                    width: screenUtil.setWidth(120.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ClipOval(
                        child: Image.network(comment.user.avatarUrl, fit: BoxFit.cover),
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenUtil.setHeight(30.0)
                            ),
                            child: Column(
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
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenUtil.setHeight(30.0)
                            ),
                            child: likeBtn(comment),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          right: screenUtil.setWidth(50.0),
                          bottom: screenUtil.setHeight(30.0)
                        ),
                        width: screenUtil.setWidth(630.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: screenUtil.setWidth(1.0),
                              color: Colors.white24
                            )
                          )
                        ),
                        child: Text(
                          comment.content,
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }, childCount: list.length),
    );
  }

  Widget whenLoadMore() {

    if (_moreComment) {
      if (status == LoadingStatus.LOADING) {
        return SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return NeteaseLoading();
          }, childCount: 1)
        );
      } else {
        return SliverFixedExtentList(
          itemExtent: 10.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return Text('');
          }, childCount: 1),
        );
      }
    } else {
      return SliverFixedExtentList(
        itemExtent: 50.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Text('到底了...');
        }, childCount: 1),
      );
    }
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
        height: 10.0,
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
            image: AssetImage('assets/images/theme_1.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverFixedExtentList(
              itemExtent: screenUtil.setHeight(200.0),
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                if (detail == null) {
                  return NeteaseLoading();
                } else {
                  return Card(
                    color: Colors.transparent,
                    margin: EdgeInsets.all(0.0),
                    clipBehavior: Clip.antiAlias,
                    semanticContainer: true,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                detail['coverImgUrl'],
                                fit: BoxFit.cover,
                              ),
                            )
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            title: Text(
                              detail['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenUtil.setSp(30.0)
                              ),
                            ),
                            subtitle: Text(
                              "${detail['creator']['nickname']}",
                              style: TextStyle(
                                color: Colors.white70
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios, color: Colors.white70),
                              onPressed: () {},
                            ),
                          ),
                        )
                      ],
                    )
                  );
                }
              }, childCount: 1),
            ),
            listTitle("精彩评论"),
            commentList(_hotComments),
            listTitle("最新评论"),
            commentList(_comments),
            // whenLoadMore()
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
      limit: 5,
      before: _lastItemTime
    );    

    status = LoadingStatus.LOADED;
    
    setState(() {
      if (_hotComments.isEmpty) {
        _hotComments = result['hotComments'];
        _moreHotComment = result['moreHot'];
      }
      _comments.addAll(result['comments']);

      _moreComment = result['more'];
    });

  }
}