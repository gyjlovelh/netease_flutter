import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/pages/playlist/playlist_actions.dart';
import 'package:netease_flutter/pages/playlist/playlist_panel.dart';
import 'package:netease_flutter/pages/playlist/playlist_songs.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/player/player.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

import 'playlist_arguments.dart';

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
      builder: (BuildContext context, AsyncSnapshot snapshot) {        
        if (snapshot.hasData) {
          PlaylistModel detail = snapshot.data;

          return Scaffold(
            // appBar: AppBar(
            //   // backgroundColor: null,
            //   title: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Text('歌单', style: TextStyle(
            //         fontSize: screenUtil.setSp(36.0)
            //       )),
            //       Text(args.copywriter ?? "", style: TextStyle(
            //         fontSize: screenUtil.setSp(20.0)
            //       ))
            //     ],
            //   ),
            //   actions: <Widget>[
            //     IconButton(
            //       onPressed: () {},
            //       icon: NeteaseIconData(0xe60c),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: Icon(Icons.list),
            //     )
            //   ],
            // ),
            body: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Stack(
                alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 80.0,
                    child: Opacity(
                      opacity: 0.1,
                      child: Container(
                        // color: Colors.white.withOpacity(0.2),
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 80.0, 
                    ),
                    margin: EdgeInsets.only(
                      // top: 80.0,
                      bottom: 50.0
                    ),
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
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 50.0,
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

