import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class PlaylistRecommend extends StatefulWidget {
  @override
  _PlaylistRecommendState createState() => _PlaylistRecommendState();
}

class _PlaylistRecommendState extends State<PlaylistRecommend> {
  ScrollController _controller;

  int _limit = 9;
  int _lastPlaylistId;

  bool _hasMore = true;

  List _plist = List();

  @override
  void initState() {
    super.initState();

    _controller = new ScrollController();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        if (_plist.isNotEmpty) {
          setState(() {
            _lastPlaylistId = _plist.last['id'];

            print(_lastPlaylistId);
          });
        }
        // _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    _loadMore();

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400.0,
              child: GridView(
                controller: _controller,
                padding: EdgeInsets.symmetric(
                  horizontal: screenUtil.setWidth(30.0),
                  vertical: screenUtil.setHeight(30.0)
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: screenUtil.setWidth(18.0),
                  crossAxisSpacing: screenUtil.setWidth(18.0)
                ),
                children: _plist.map((item) {
                  // PlaylistModel model = PlaylistModel.fromJson(item);
                  // model.coverImgUrl
                  return Column(
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
                      ),
                      Text(item['name'], 
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black87
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
            
          ],
        )
      )
    );
  }

  _loadMore() async {
    if (_hasMore) {
      final response = await RequestService.getInstance(context: context).getPlaylistHighquality(
        limit: _limit,
        before: _lastPlaylistId
      );

      print(response);

      setState(() {
        _hasMore = response['more'];
        _plist = response['playlists'];
        // _plist.addAll(response['playlists']);
      });
    } else {

    }
    
  }
}
