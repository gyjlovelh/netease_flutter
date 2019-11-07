import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/playlist_arguments.dart';
import 'package:netease_flutter/pages/playlist/playlist_actions.dart';
import 'package:netease_flutter/pages/playlist/playlist_panel.dart';
import 'package:netease_flutter/pages/playlist/playlist_songs.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';


class NeteasePlaylist extends StatefulWidget {
  @override
  _NeteasePlaylistState createState() => _NeteasePlaylistState();
}

class _NeteasePlaylistState extends State<NeteasePlaylist> {
  LoadingStatus status = LoadingStatus.UNINIT;
  PlaylistModel detail;
  PlaylistArguments arguments;

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 跳转需要参数 {id, 歌单名, 封面, 推荐语}
    arguments = PlaylistArguments.fromJson(json.decode(ModalRoute.of(context).settings.arguments));
    if (status == LoadingStatus.UNINIT) {
      _getPageData();
    }

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: arguments.name,
        subtitle: arguments.copywriter
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(0, 0),
            end: FractionalOffset(1, 1),
            colors: [Color.fromRGBO(40, 61, 76, 1), Color.fromRGBO(69, 105, 123, 1)]
          ),
        ),
        child: Column(
          children: <Widget>[
            new NeteasePlaylistPanel(detail: detail, arguments: arguments, status: status),
            new NeteasePlaylistActions(detail: detail, status: status),
            new NeteasePlaylistSongs(detail: detail, status: status)
          ],
        ),
      )
    );
  }

  void _getPageData() async {
    status = LoadingStatus.LOADING;
    final result = await RequestService.getInstance(context: context).getPlaylistDetail(arguments.id);
    setState(() {
      status = LoadingStatus.LOADED;
      detail = result;
    });
  }
}

