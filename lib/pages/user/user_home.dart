import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/playlist_arguments.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';

class UserHome extends StatefulWidget {
  final ProfileModel profile;
  final int listenSongs;

  UserHome({this.profile, this.listenSongs});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  LoadingStatus status = LoadingStatus.UNINIT;
  List _playlist = [];

  Widget _commentLisTile({
    @required String subtitle,
    @required String title,
    @required Image leading,
    @required VoidCallback onPressed
  }) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return ListTile(
      onTap: onPressed,
      onLongPress: () {},
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(screenUtil.setWidth(12.0)),
        child: leading,
      ),
      title: Text(
        "$title",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenUtil.setSp(32.0)
        ),
      ),
      subtitle: Text(
        "$subtitle",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white70,
          fontSize: screenUtil.setSp(24.0)
        ),
      ),
    );
  }

  // 播放记录
  Widget rankList() {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    return _commentLisTile(
      onPressed: () {
        Navigator.of(context).pushNamed('play_record', arguments: json.encode({
          "userId": widget.profile.userId,
          "nickname": widget.profile.nickname
        }));
      },
      leading: Image.asset(
        "assets/images/theme.jpeg",
        fit: BoxFit.cover,
        width: screenUtil.setWidth(120.0),
        height: screenUtil.setWidth(120.0),
      ),
      title: "${widget.profile.nickname}的听歌排行",
      subtitle: "累计听歌${widget.listenSongs}首"
    );
  }

  // 标题行
  Widget commentTitle({String title, String desc}) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Padding(
      padding: EdgeInsets.only(
        left: screenUtil.setWidth(40.0),
        top: screenUtil.setHeight(50.0)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "$title",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(36.0)
            ),
          ),
          Text(
            "$desc",
            style: TextStyle(
              color: Colors.white54,
              fontSize: screenUtil.setSp(26.0)
            ),
          )
        ],
      ),
    );
  }

  // 歌单行
  Widget commentListTile(params) {
    PlaylistModel model = PlaylistModel.fromJson(params);
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return _commentLisTile(
      onPressed: () {
        PlaylistArguments arguments = new PlaylistArguments();
        arguments.id = model.id;
        arguments.name = model.name;
        arguments.coverImgUrl = model.coverImgUrl;
        Navigator.of(context).pushNamed('playlist', arguments: json.encode(arguments.toJson()));
      },
      leading: Image.network(
        model.coverImgUrl,
        fit: BoxFit.cover,
        width: screenUtil.setWidth(120.0),
        height: screenUtil.setWidth(120.0),
      ),
      title: "${model.name}",
      subtitle: "${model.trackCount}首，播放${model.playCount}次"
    );
  }

  // 更多歌单
  Widget morePlaylist() {
    return Container(
      width: ScreenUtil.getInstance().setWidth(750.0),
      child: FlatButton(
        textColor: Colors.white70,
        child: Text('更多歌单 > '),
        onPressed: () {
          // Navigator.of(context).pushNamed('')
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status != LoadingStatus.LOADED) {
      if (status == LoadingStatus.UNINIT) {
        _loadPageData();
      }
      return Center(
        child: NeteaseLoading(),
      );
    } else {
      // 喜欢的音乐
      final _favePlaylist = _playlist.sublist(0, 1);
      List _createPlaylist = _playlist.sublist(1).where((item) => item['userId'] == widget.profile.userId).toList();
      List _storePlaylist = _playlist.sublist(1).where((item) => item['userId'] != widget.profile.userId).toList();

      List<Widget> contents = [];
      contents.add(rankList());
      contents.add(commentListTile(_favePlaylist.first));
      if (_createPlaylist.length > 0) {
        contents.add(commentTitle(title: "创建的歌单", desc: "(${_createPlaylist.length}个，被收藏${widget.profile.playlistBeSubscribedCount}次)"));
        List _list = _createPlaylist.sublist(0, min(3, _createPlaylist.length));
        contents.addAll(_list.map((item) => commentListTile(item)).toList());
        if (_createPlaylist.length > 3) {
          contents.add(morePlaylist());
        }
      }

      if (_storePlaylist.length > 0) {
        contents.add(commentTitle(title: "收藏的歌单", desc: "(${_storePlaylist.length})"));
        List _list = _storePlaylist.sublist(0, min<int>(3, _storePlaylist.length));
        contents.addAll(_list.map((item) => commentListTile(item)).toList());
        if (_createPlaylist.length > 3) {
          contents.add(morePlaylist());
        }
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: contents,
        ),
      );
    }
  }

  void _loadPageData() async {
    setState(() {
      status = LoadingStatus.LOADING;
    });

    final result = await RequestService.getInstance(context: context).getUserPlaylist(widget.profile.userId);

    setState(() {
      status = LoadingStatus.LOADED;
      _playlist = result['playlist'];
    });
  }
}