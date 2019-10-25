import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/search_result/result_user.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

import 'result_album.dart';
import 'result_playlist.dart';
import 'result_song.dart';
import 'result_singer.dart';

class NeteaseSearchResult extends StatefulWidget {

  @override
  _NeteaseSearchResultState createState() => _NeteaseSearchResultState();
}

class _NeteaseSearchResultState extends State<NeteaseSearchResult> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = new TextEditingController();
  TabController _tabController;

  dynamic _searchDefault;

  List _tabs = [ "单曲", "视频", "歌手", "专辑", "歌单", "用户"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    RequestService.getInstance(context: context).getSearchDefault().then((result) {
      _searchDefault = result;
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    String searchWord = ModalRoute.of(context).settings.arguments;
    _searchController.text = searchWord;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenUtil.setSp(28.0)
          ),
          decoration: InputDecoration(
            hintText: _searchDefault == null ? "" : _searchDefault['showKeyword'],
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: screenUtil.setSp(28.0)
            )
          ),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,

          tabs: _tabs.map((item) {
            return Tab(
              child: Container(
                width: screenUtil.setWidth(150.0),
                child: Text(
                  item, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenUtil.setSp(30.0)
                  )
                ),
              ),
            );
          }).toList()
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/theme_1.jpg'
            ),
            fit: BoxFit.cover
          )
        ),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((item) {
                    var sw = _searchController.text.trim() ?? _searchDefault["realkeyword"];
                    if (item == "单曲") {
                      return new ResultSong(searchWord: sw);
                    } else if (item == "歌单") {
                      return new ResultPlaylist(searchWord: sw);
                    } else if (item == "歌手") {
                      return new ResultSinger(searchWord: sw);
                    } else if (item == "用户") {
                      return new ResultUser(searchWord: sw);
                    } else if (item == "专辑") {
                      return new ResultAlbum(searchWord: sw);
                    } else {
                      return Text('todo');
                    }
                  }).toList(),
                ),
              ),
            ),
            // Expanded(
            //   flex: 0,
            //   child: Container(
            //     height: screenUtil.setHeight(Global.PLAYER_SCALE * screenUtil.height),
            //     child: new NeteasePlayer(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}