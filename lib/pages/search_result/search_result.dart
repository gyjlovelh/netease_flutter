import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/search_result/result_user.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

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

  LoadingStatus status = LoadingStatus.UNINIT;

  dynamic _searchDefault;

  List _tabs = [ "单曲", "视频", "歌手", "专辑", "歌单", "用户"];
  List _matchs = [];
  String _searchWord = '';
  bool _inputFocused = false;

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

  Widget searchSuggestPanel() {
    ScreenUtil screenUtil = ScreenUtil.getInstance(); 
    if (_matchs.length == 0 || !_inputFocused) {
      return Positioned(
        bottom: 0,
        height: 0,
        width: 0,
        child: Text(''),
      );
    } else {
      return Positioned(
        left: screenUtil.setWidth(35.0),
        top: screenUtil.setHeight(10.0),
        right: screenUtil.setWidth(120.0),
        height: screenUtil.setHeight(_matchs.length * 120.0),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            itemCount: _matchs.length,
            itemExtent: screenUtil.setHeight(120.0),
            itemBuilder: (BuildContext context, int index) {
              final item = _matchs[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    _searchController.text = item['keyword'];
                    _searchWord = item['keyword'];
                    _inputFocused = false;
                  });
                },
                leading: Container(
                  width: screenUtil.setWidth(50.0),
                  child: Center(
                    child: NeteaseIconData(
                      0xe60c,
                      color: Colors.white70,
                      size: screenUtil.setSp(36.0),
                    ),
                  ),
                ),
                title: Text(
                  "${item['keyword']}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenUtil.setSp(28.0)
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    if (status == LoadingStatus.UNINIT) {
      String searchWord = ModalRoute.of(context).settings.arguments;
      _searchController.text = searchWord;
      _searchWord = searchWord;
      setState(() {
        status = LoadingStatus.LOADED;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onTap: () {
            setState(() {
              _inputFocused = true;
              if (_searchController.text.trim().isNotEmpty) {
                _loadSearchSuggest(_searchController.text.trim());
              }
            });
          },
          onChanged: (String text) {
            if (text.trim().isNotEmpty) {
              _loadSearchSuggest(text.trim());
            } else {
              setState(() {
                _matchs = [];
              });
            }
          },
          style: TextStyle(
            color: Colors.white,
            fontSize: screenUtil.setSp(28.0)
          ),
          decoration: InputDecoration(
            hintText: _searchDefault == null ? "" : _searchDefault['showKeyword'],
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: screenUtil.setSp(28.0)
            ),
            border: InputBorder.none
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Listener(
            onPointerDown: (PointerDownEvent event) {
              setState(() {
                _inputFocused = false;
              });
            },
            child: Container(
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
                          if (item == "单曲") {
                            return new ResultSong(searchWord: _searchWord);
                          } else if (item == "歌单") {
                            return new ResultPlaylist(searchWord: _searchWord);
                          } else if (item == "歌手") {
                            return new ResultSinger(searchWord: _searchWord);
                          } else if (item == "用户") {
                            return new ResultUser(searchWord: _searchWord);
                          } else if (item == "专辑") {
                            return new ResultAlbum(searchWord: _searchWord);
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
          ),
          searchSuggestPanel()
        ],
      )
    );
  }

  void _loadSearchSuggest(String text) async {
    final result = await RequestService.getInstance(context: context).getSearchSuggest(text);

    print(result['allMatch']);
    setState(() {
      _matchs = result['allMatch'] ?? [];
    });
  }
}