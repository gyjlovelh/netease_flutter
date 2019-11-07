import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/comment.dart';
import 'package:netease_flutter/models/comment_arguments.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteaseComment extends StatefulWidget {

  @override
  _NeteaseCommentState createState() => _NeteaseCommentState();
}

class _NeteaseCommentState extends State<NeteaseComment> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  ProfileModel _beReplier;

  CommentArguments arguments;
  Map<String, dynamic> detail;
  LoadingStatus status = LoadingStatus.UNINIT;

  // 热门评论
  List _hotComments = [];
  List _comments = [];

  bool _moreHotComment = true;
  int _limit = 20;
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
        if (status != LoadingStatus.LOADING) {
          if (_comments.isNotEmpty) {
            _lastItemTime = _comments.last['time'];
          }
          _loadCommentMore();     
        } 
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget targetDetail() {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SliverFixedExtentList(
      itemExtent: screenUtil.setHeight(200.0),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        if (arguments.type == 'music') {
          return Text('todo');
        }
        if (detail == null && detail.isEmpty) {
          return NeteaseLoading();
        } else {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Card(
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
                          "${detail['coverImgUrl']}",
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
                          fontSize: SizeSetting.size_14
                        ),
                      ),
                      subtitle: Text(
                        "by ${detail['id']} ${detail['creator']['nickname']}",
                        style: TextStyle(
                          color: Colors.white70
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(
                          right: SizeSetting.size_10
                        ),
                        child: NeteaseIconData(
                          0xe626,
                          color: Colors.white70,
                          size: screenUtil.setSp(42.0),
                        ),
                      ),
                      dense: true,
                    ),
                  )
                ],
              )
            ),
          );
        }
      }, childCount: 1),
    );
  }

  Widget publishDate(CommentModel comment) {
    String timeStamp;
    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(comment.time);
      timeStamp = "${time.month}月${time.day}日";
    } catch (err) {
      timeStamp = "未知";
    }
    return Text(
      "$timeStamp",
      style: TextStyle(
        color: Colors.white54,
        fontSize: SizeSetting.size_10
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
          crossAxisAlignment: CrossAxisAlignment.end,
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
                  fontSize: SizeSetting.size_10
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
            top: screenUtil.setHeight(15.0)
          ),
          padding: EdgeInsets.only(
            top: screenUtil.setHeight(15.0),
            left: screenUtil.setWidth(30.0)
          ),
          color: Colors.black12,
          child: Text(
            '$title',
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeSetting.size_16,
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
        return Material(
          color: Colors.black12,
          child: InkWell(
            onTap: () async {
              final scope = FocusScope.of(context);
              // 打开评论出入框、、带入回复人信息
              showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  backgroundColor: Theme.of(context).primaryColor,
                  children: [
                    {"label": "回复评论", "onPressed": () {
                      Navigator.of(context).pop();
                      _focusNode.unfocus();
                      scope.requestFocus(_focusNode);
                      setState(() {
                        _beReplier = comment.user;
                      });
                    }},
                    {"label": "复制评论", "onPressed": null},
                  ].map((item) => InkWell(
                    onTap: item['onPressed'],
                    child: ListTile(
                      title: Text(
                        "${item['label']}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenUtil.setSp(24.0)
                        ),
                      ),
                      dense: true,
                    ),
                  )).toList()
                )
              );
            },
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('user', arguments: comment.user.userId);
                    },
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
                  )
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
                          top: screenUtil.setHeight(8.0),
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
                          "${comment.content}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeSetting.size_12
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
            targetDetail(),
            listTitle("精彩评论"),
            commentList(_hotComments),
            listTitle("最新评论"),
            commentList(_comments),
            whenLoadMore()
          ],
        ),
      ),
      customFooter: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenUtil.setWidth(35.0)
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/player_bar_1.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: _beReplier == null ? '这一次也许就是你上热评了' : '回复${_beReplier.nickname}：',
                  hintStyle: TextStyle(
                    color: Theme.of(context).textSelectionColor.withOpacity(0.6),
                    fontSize: SizeSetting.size_14
                  ),
                  border: InputBorder.none
                ),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: SizeSetting.size_14
                ),
              ),
            ),
            // todo表情
            Expanded(
              flex: 0,
              child: FlatButton(
                textColor: Colors.white70,
                child: Text('发送', 
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: SizeSetting.size_14
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        )
      ),
    );
  }

  void _loadTargetDetail() async {
    var result;
    if (arguments.type == 'playlist') {
      result = await RequestService.getInstance(context: context).getPlaylistDetail(arguments.id);
    } else if (arguments.type == 'music') {
      result = await RequestService.getInstance(context: context).getSongDetail(arguments.id);
    }

    setState(() {
      status = LoadingStatus.LOADED;
      detail = result.toJson();
    });
  }

  void _loadCommentMore() async {
    
    setState(() {
      status = LoadingStatus.LOADING;
    });

    final result = await RequestService.getInstance(context: context).getComments(
      type: arguments.type,
      id: arguments.id,
      limit: _limit,
      before: _lastItemTime
    );        
    setState(() {
      if (_hotComments.isEmpty) {
        _hotComments = result['hotComments'];
        _moreHotComment = result['moreHot'];
      }
      _comments.addAll(result['comments']);

      _moreComment = result['more'];
      status = LoadingStatus.LOADED;
    });

  }
}