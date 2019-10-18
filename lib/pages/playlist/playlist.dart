import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/pages/playlist/playlist_actions.dart';
import 'package:netease_flutter/pages/playlist/playlist_panel.dart';
import 'package:netease_flutter/pages/playlist/playlist_songs.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/player/player.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class NeteasePlaylist extends StatefulWidget {
  @override
  _NeteasePlaylistState createState() => _NeteasePlaylistState();
}

class _NeteasePlaylistState extends State<NeteasePlaylist> {

  @override
  Widget build(BuildContext context) {
    var arguments = json.decode(ModalRoute.of(context).settings.arguments);

    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return FutureBuilder(
      future: RequestService.getInstance(context: context).getPlaylistDetail(arguments['id']),
      builder: (BuildContext context, AsyncSnapshot snapshot) {        
        if (snapshot.hasData) {
          PlaylistModel detail = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              // backgroundColor: null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('歌单', style: TextStyle(
                    fontSize: screenUtil.setSp(36.0)
                  )),
                  Text(arguments['copywriter'], style: TextStyle(
                    fontSize: screenUtil.setSp(20.0)
                  ))
                ],
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: NeteaseIconData(0xe60c),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.list),
                )
              ],
            ),
            body: Container(
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/bg_blur.jpeg'),
                                fit: BoxFit.cover
                              )
                            ),
                            child: Column(
                              children: <Widget>[
                                new NeteasePlaylistPanel(detail: detail),
                                new NeteasePlaylistActions(detail: detail),
                                new NeteasePlaylistSongs(detail: detail)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Container(
                    height: screenUtil.setHeight(screenUtil.height * 1.2 / 14),
                    child: new NeteasePlayer(),
                  )
                ],
              ),
            )
          );
        } else {
          return Text('loading...');
        }
      },      
    );
  }
}
