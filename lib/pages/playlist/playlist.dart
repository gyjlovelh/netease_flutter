import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/playlist_arguments.dart';
import 'package:netease_flutter/pages/playlist/playlist_actions.dart';
import 'package:netease_flutter/pages/playlist/playlist_panel.dart';
import 'package:netease_flutter/pages/playlist/playlist_songs.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';


class NeteasePlaylist extends StatefulWidget {
  @override
  _NeteasePlaylistState createState() => _NeteasePlaylistState();
}

class _NeteasePlaylistState extends State<NeteasePlaylist> {

  @override
  Widget build(BuildContext context) {
    // 跳转需要参数 {id, 歌单名, 封面, 推荐语}
    PlaylistArguments args = PlaylistArguments.fromJson(json.decode(ModalRoute.of(context).settings.arguments));

    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return FutureBuilder(
      future: RequestService.getInstance(context: context).getPlaylistDetail(args.id),
      initialData: new PlaylistModel(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {        
        PlaylistModel detail = snapshot.data;
        return NeteaseScaffold(
          appBar: NeteaseAppBar(
            title: args.name,
            subtitle: args.copywriter
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 1),
                colors: [Color.fromRGBO(75, 49, 49, 1), Color.fromRGBO(40, 56, 53, 1)]
              ),
            ),
            child: Column(
              children: <Widget>[
                new NeteasePlaylistPanel(detail: detail, arguments: args),
                new NeteasePlaylistActions(detail: detail),
                new NeteasePlaylistSongs(detail: detail)
              ],
            ),
          )
        );
      },      
    );
  }
}

