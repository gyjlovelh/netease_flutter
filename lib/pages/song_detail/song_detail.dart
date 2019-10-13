import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

import 'play_icon_action.dart';
import 'song_cover.dart';

class NeteaseSongDetail extends StatefulWidget {
  @override
  _NeteaseSongDetailState createState() => _NeteaseSongDetailState();
}

class _NeteaseSongDetailState extends State<NeteaseSongDetail> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return FutureBuilder(
      future: RequestService.getInstance().getSongDetail('1374056688'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      
        if (snapshot.hasData) {
          SongModel song = SongModel.fromJson(json.decode(snapshot.data.toString())['songs'][0]);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(song.name + song.id.toString(), style: TextStyle(
                    fontSize: screenUtil.setSp(30.0)
                  )),
                  Text(song.ar.map((item) => item.name).join(','), style: TextStyle(
                    fontSize: screenUtil.setSp(24.0)
                  ))
                ],
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/theme.jpeg'),
                  fit: BoxFit.cover
                )
              ),
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  new NeteaseSongCover(song: song),
                  new NeteasePlayIconAction(song: song)
                ],
              ),
            )
          );
        } else {
          return Center(child: Text('loading'));
        }
        
      },
    );
  }
}