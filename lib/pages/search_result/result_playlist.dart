import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';

class ResultPlaylist extends StatefulWidget {

  final String searchWord;
  ResultPlaylist({@required this.searchWord});

  @override
  _ResultPlaylistState createState() => _ResultPlaylistState();
}

class _ResultPlaylistState extends State<ResultPlaylist> {
  final int _limit = 20;
  ScrollController _controller;
  List _plist = List();
  int _plCount = 0;

  int _offset = 0; // 偏移量
  bool _hasMore = true; // 是否已经到底.

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_offset + _limit > _plCount) {
          // 已经到底了
          _hasMore = false;
        } else {
          _offset += _limit;
          _loadMore();        
        }
      }
    });

    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getSubtitle(PlaylistModel model) {
    String content = "";
    String playCountStr = "";
    content += model.trackCount.toString() + "首 ";
    content += "by " + model.creator.nickname + ",";
    if (model.playCount > 100000000) {
      playCountStr = (model.playCount ~/ 100000000).toString() + "亿次";
    } else if (model.playCount > 100000) {
      playCountStr = (model.playCount ~/ 1000 / 10).toString() + "万次";
    } else {
      playCountStr = model.playCount.toString() + "次";
    }
    content += " 播放$playCountStr";
    return Text(content, 
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white70,
        fontSize: ScreenUtil.getInstance().setSp(22.0)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      child: Container(
        height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
        child: ListView(
          itemExtent: screenUtil.setHeight(120.0),
          controller: _controller,
          children: _plist.map((item) {
            PlaylistModel model = PlaylistModel.fromJson(item);
            return ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('playlist', arguments: json.encode({
                  "id": model.id, 
                  "name": model.name,
                  "coverImgUrl": model.coverImgUrl
                }).toString());
              },
              leading: Container(
                width: screenUtil.setHeight(90.0),
                height: screenUtil.setHeight(90.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(model.coverImgUrl),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(
                    screenUtil.setWidth(8.0)
                  )
                ),
              ),
              title: Text(model.name, style: TextStyle(
                color: Colors.white,
                fontSize: screenUtil.setSp(28.0)
              )),
              subtitle: getSubtitle(model),
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _loadMore() async {
    var response = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.searchWord,
      type: 1000,
      limit: _limit,
      offset: _offset
    );

    setState(() {
      _plist.addAll(response['playlists']);
      _plCount = response['playlistCount'];
    });
  }
}