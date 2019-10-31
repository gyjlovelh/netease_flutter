import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/list_tile/list_tile.dart';
class ResultSong extends StatefulWidget {

  final String searchWord;
  ResultSong({@required this.searchWord});

  @override
  _ResultSongState createState() => _ResultSongState();
}

class _ResultSongState extends State<ResultSong> {
  ScrollController _controller;
  List _songs = List();
  int _offset = 0; // 偏移量
  int _songCount = 0;
  bool _hasMore = true; // 是否已经到底.

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_offset + 30 > _songCount) {
          // 已经到底了
          _hasMore = false;
        } else {
          _offset += 30;
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

  Widget getSongTitle(SongModel song) {
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
        fontSize: screenUtil.setSp(28.0)
      ))
    );
  }

  Widget getSubtitle(SongModel song) {
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
          fontSize: screenUtil.setSp(24.0)
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      child: SingleChildScrollView(
        child: Container(
          height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
          child: ListView(
            controller: _controller,
            children: _songs.map((item) {
              SongModel song = SongModel.fromJson(item);

              return NeteaseListTile(
                listTile: ListTile(
                  title: getSongTitle(song),
                  subtitle: getSubtitle(song),
                  trailing: GestureDetector(
                    child: NeteaseIconData(
                      0xe8f5,
                      size: screenUtil.setSp(36.0),
                      color: Colors.white70,
                    ),
                    onTap: () {},
                  ),
                  enabled: true,
                  dense: true,
                  onTap: () {

                  },
                ),
              );
            }).toList(),
          ),
        )
      ),
    );
  }

  _loadMore() async {
    var result = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.searchWord,
      type: 1,
      limit: 20,
      offset: _offset
    );

    setState(() {
      _songs.addAll(result['songs']);
      _songCount = result['songCount'];
    });
  }
}