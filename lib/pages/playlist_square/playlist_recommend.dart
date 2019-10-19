import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/playcount/playcount.dart';

class PlaylistRecommend extends StatefulWidget {
  final String cat;
  PlaylistRecommend({@required this.cat});

  @override
  _PlaylistRecommendState createState() => _PlaylistRecommendState();
}

class _PlaylistRecommendState extends State<PlaylistRecommend> {
  ScrollController _controller;

  int _limit = 30;
  int _lastPlaylistUpdateTime; // 记录上一页最后一条更新时间

  bool _hasMore = true; // 是否已经到底
  bool _hasInit = false; // 首次加载
  LoadingStatus _loading = LoadingStatus.LOADING;

  List _plist = List(); // 歌单

  @override
  void initState() {
    super.initState();

    _controller = new ScrollController();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_plist.isNotEmpty) {
          _lastPlaylistUpdateTime = _plist.last['updateTime'];
        }
        _loadMore();        
      }
    });

    _loadMore();        
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget customLoading() {
    String message;
    bool visible;
    if (_hasMore) {
      if (_loading == LoadingStatus.LOADING) {
        message = '努力加载中...';
        visible = true;
      } else {
        message = '';
        visible = false;
      }
    } else {
      visible = true;
      message = '已经到底了';
    }
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      height: screenUtil.setHeight(visible ? 50.0 : 0.0),
      child: Center(
        child: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (_hasInit) {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height - 90 - (_hasMore && _loading == LoadingStatus.COMPLETED ? 0.0 : 50.0)),
                child: GridView(
                  controller: _controller,
                  padding: EdgeInsets.only(
                    top: screenUtil.setWidth(30.0),
                    left: screenUtil.setWidth(30.0),
                    right: screenUtil.setWidth(30.0),
                    bottom: screenUtil.setWidth(0.0)
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: screenUtil.setWidth(18.0),
                    crossAxisSpacing: screenUtil.setWidth(18.0)
                  ),
                  children: _plist.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('playlist', arguments: json.encode({"id": item['id'], "copywriter": item['copywriter'] ?? ""}).toString());
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: screenUtil.setWidth(230.0),
                            height: screenUtil.setWidth(230.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(item['coverImgUrl']),
                                fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(
                                screenUtil.setWidth(10.0)
                              )
                            ),
                            child: new NeteasePlaycount(playCount: item['playCount']),
                          ),
                          Text(item['name'], 
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenUtil.setSp(24.0)
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              customLoading()
            ],
          )
        )
      );
    } else {
      return Center(
        child: Text('努力加载中...'),
      );
    }
  }

  _loadMore() async {
    if (_hasMore) {
      setState(() {
        _loading = LoadingStatus.LOADING;
      });
      var response;
      if (widget.cat == "精品") {
        response = await RequestService.getInstance(context: context).getPlaylistHighquality(
          limit: _limit,
          before: _lastPlaylistUpdateTime
        );
      } else {
        response = await RequestService.getInstance(context: context).getPlaylist(
          limit: _limit,
          before: _lastPlaylistUpdateTime,
          cat: widget.cat == "推荐" ? "" : widget.cat
        );
      }
      setState(() {
        if (_hasInit == false) {
          _hasInit = true;
        }
        _hasMore = response['more'];
        _loading = LoadingStatus.COMPLETED;
        List playlists = response['playlists'];
        _plist.addAll(playlists);
      });
    } else {

    }
    
  }
}
