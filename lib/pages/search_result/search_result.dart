import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/list_tile/list_tile.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';
import 'package:provider/provider.dart';

import 'result_list.dart';

class NeteaseSearchResult extends StatefulWidget {

  @override
  _NeteaseSearchResultState createState() => _NeteaseSearchResultState();
}

class _NeteaseSearchResultState extends State<NeteaseSearchResult> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = new TextEditingController();
  TabController _tabController;

  LoadingStatus status = LoadingStatus.UNINIT;

  dynamic _searchDefault;

  List<TabItemSetting> _tabs = [];
  List _matchs = [];
  String _searchWord = '';
  bool _inputFocused = false;

  @override
  void initState() {
    super.initState();
    _tabs..add(new TabItemSetting( ///单曲
      type: 1,
      label: '单曲',
      listKey: "songs", 
      countKey: "songCount",
      itemBuilder: songBuilder
    ))..add(new TabItemSetting( /// 歌手
      type: 100,
      label: '歌手',
      listKey: 'artists',
      countKey: 'artistCount',
      itemBuilder: artistBuilder
    ))..add(new TabItemSetting( ///专辑
      type: 10,
      label: '专辑',
      listKey: 'albums',
      countKey: 'albumCount',
      itemBuilder: ablumBuilder
    ))..add(new TabItemSetting(
      type: 1000,
      label: '歌单',
      listKey: 'playlists',
      countKey: 'playlistCount',
      itemBuilder: playlistBuilder
    ))..add(new TabItemSetting(
      type: 1002,
      label: '用户',
      listKey: 'userprofiles',
      countKey: 'userprofileCount',
      itemBuilder: profileBuilder
    ));
    
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

  // 搜索建议面板
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

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        customTitle: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(101, 129, 140, 0.7),
                width: screenUtil.setHeight(1.0)
              )
            ),
            // color: Colors.tealAccent
          ),
          height: 35,
          margin: EdgeInsets.only(
            bottom: 5.0,
            top: 10.0,
            right: screenUtil.setWidth(35.0)
          ),
          child: TextField(
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
              color: Colors.white70,
              fontSize: SizeSetting.size_14
            ),
            decoration: InputDecoration(
              hintText: _searchDefault == null ? "" : _searchDefault['showKeyword'],
              hintStyle: TextStyle(
                color: Theme.of(context).inputDecorationTheme.hintStyle.color,
                fontSize: SizeSetting.size_14
              ),
              border: InputBorder.none
            ),
          ),
        )

      ),
      tabbar: TabBar(
        isScrollable: true,
        controller: _tabController,
        labelColor: Theme.of(context).textSelectionColor,
        unselectedLabelColor: Colors.white70,
        tabs: _tabs.map((item) {
          return Tab(
            child: Container(
              width: screenUtil.setWidth(150.0),
              child: Text(
                item.label, 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeSetting.size_14
                )
              ),
            ),
          );
        }).toList()
      ),
      body: Stack(
        fit: StackFit.loose,
        overflow: Overflow.clip,
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
                  image: AssetImage('assets/images/theme_1.jpg'),
                  fit: BoxFit.cover
                )
              ),
              height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 130.0,
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((item) {
                  return new ResultList(
                    keyword: _searchWord,
                    type: item.type,
                    listKey: item.listKey,
                    countKey: item.countKey,
                    itemBuilder: item.itemBuilder,
                  );
                }).toList(),
              ),
            )
          ),
          searchSuggestPanel()
        ],
      ),
    );
  }

  void _loadSearchSuggest(String text) async {
    final result = await RequestService.getInstance(context: context).getSearchSuggest(text);

    print(result['allMatch']);
    setState(() {
      _matchs = result['allMatch'] ?? [];
    });
  }

  //////////////////////////////////////////// result-song[单曲] ////////////////////////////////////////////////////
  Widget songBuilder(item) {
    SongModel song = SongModel.fromJson(item);
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    return NeteaseListTile(
      listTile: ListTile(
        title: songTitle(song),
        subtitle: songSubtitle(song),
        trailing: GestureDetector(
          child: NeteaseIconData(
            0xe8f5,
            size: SizeSetting.size_14,
            color: Colors.white70,
          ),
          onTap: () {},
        ),
        enabled: true,
        dense: true,
        onTap: () async {
          ///加载歌曲播放链接
          ///更新播放列表。开始播放选中歌曲。
          ///跳转到歌曲播放界面
          SongModel model = await RequestService.getInstance(context: context).getSongDetail(song.id);
          demandProvider.addMusicItem(model);
          demandProvider.loadMusic(model);

          Navigator.of(context).pushNamed('song_detail');
        },
      ),
    );
  }

  Widget songTitle(SongModel song) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    String extra = "";
    if (song.transNames != null && song.transNames.length > 0) {
      extra = '(' + song.transNames.join(',') + ')';
    }

    return Container(
      child: Text(song.name + extra, 
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
        color: Colors.white,
        fontSize: SizeSetting.size_14
      ))
    );
  }

  Widget songSubtitle(SongModel song) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    String extra = "";
    if (song.album != null) {
      extra = " - " + song.album.name;
    }

    return Container(
      child: Text(
        song.artists.map((item) => item.name).join(',') + extra, 
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white70,
          fontSize: SizeSetting.size_10
        ),
      ),
    );
  }

  //////////////////////////////////////////// result-album[专辑] //////////////////////////////////////////////////// 
  Widget ablumBuilder(item) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return NeteaseListTile(
      listTile: ListTile(
        leading: Container(
          height: screenUtil.setHeight(90.0),
          width: screenUtil.setHeight(90.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(item['picUrl']),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0))
          ),
          // child: ,
        ),
        title: Text(item['name'], style: TextStyle(
          fontSize: SizeSetting.size_14,
          color: Colors.white
        )),
        subtitle: Text(item['artist']['name'], style: TextStyle(
          color: Colors.white70,
          fontSize: SizeSetting.size_10
        )),
      ),
    );
  }

  //////////////////////////////////////////// result-artist [歌手] ////////////////////////////////////////////////////
  Widget artistBuilder(item) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    return NeteaseListTile(
      listTile: ListTile(
        onTap: () {
          
        },
        leading: Container(
          height: screenUtil.setHeight(90.0),
          width: screenUtil.setHeight(90.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                item['img1v1Url']
              ),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(999.0)
          ),
        ),
        title: Text(item['name'], style: TextStyle(
          color: Colors.white,
          fontSize: SizeSetting.size_14
        )),
        trailing: Container(
          width: screenUtil.setWidth(180.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  right: screenUtil.setWidth(10.0)
                ),
                padding: EdgeInsets.all(screenUtil.setWidth(8.0)),
                decoration: BoxDecoration(
                  color: Theme.of(context).textSelectionColor,
                  borderRadius: BorderRadius.circular(999.0)
                ),
                child: NeteaseIconData(
                  0xe68e,
                  color: Colors.white,
                  size: screenUtil.setSp(18.0),
                ),
              ),
              Text('已入驻', style: TextStyle(
                color: Colors.white70,
                fontSize: SizeSetting.size_12
              ))
            ],
          ),
        ),
        dense: true,
      ),
    );
  }

  //////////////////////////////////////////// result-playlist[歌单] ////////////////////////////////////////////////////
  Widget playlistBuilder(item) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    PlaylistModel model = PlaylistModel.fromJson(item);
    return NeteaseListTile(
      listTile: ListTile(
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
        title: Text(
          model.name, 
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeSetting.size_14
          )),
        subtitle: playlistSubtitle(model),
        dense: true,
      ),
    );
  }
  
  Widget playlistSubtitle(PlaylistModel model) {
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
        fontSize: SizeSetting.size_10
      )
    );
  }

  //////////////////////////////////////////// result-profile[用户] ////////////////////////////////////////////////////
  Widget profileBuilder(item) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    ProfileModel profile = ProfileModel.fromJson(item);
    return NeteaseListTile(
      listTile: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('user', arguments: profile.userId);
        },
        leading: Container(
          height: screenUtil.setHeight(90.0),
          width: screenUtil.setHeight(90.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                profile.avatarUrl
              ),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.circular(999.0)
          ),
        ),
        title: Container(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  right: 5.0,
                ),
                child: Text(profile.nickname, style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeSetting.size_14
                )),
              ),
              genderIcon(profile)
            ],
          ),
        ),
        subtitle: Text(profile.signature ?? "", 
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white70,
            fontSize: SizeSetting.size_10
          )
        ),
        dense: true,
        trailing: Container(
          width: screenUtil.setWidth(120.0),
          height: screenUtil.setHeight(42.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: screenUtil.setWidth(1.0),
              color: Theme.of(context).textSelectionColor,
            ),
            borderRadius: BorderRadius.circular(999.0)
          ),
          padding: EdgeInsets.zero,
          child: FlatButton(
            padding: EdgeInsets.zero,
            textColor: Theme.of(context).textSelectionColor,
            child: Text('+ 关注', style: TextStyle(
              fontSize: SizeSetting.size_10
            )),
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {},
          ),
        )
      ),
    );
  }
  
  Widget genderIcon(ProfileModel profile) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (profile.gender == 1) {
      return NeteaseIconData(
        0xe62c,
        color: Colors.blueAccent,
        size: screenUtil.setSp(20.0),
      );
    } else if (profile.gender == 2) {
      return NeteaseIconData(
        0xe671,
        color: Colors.redAccent,
        size: screenUtil.setSp(20.0),
      );
    } else {
      return Text('');
    }
  }
}

class TabItemSetting {
  final String label;
  final int type;
  final String listKey;
  final String countKey;
  final ResultBuilder itemBuilder;
  // 上一次关键字
  String historyKeyword = "";
  Widget resultPage;

  TabItemSetting({
    this.label,
    this.countKey,
    this.itemBuilder,
    this.type,
    this.listKey
  });
}

