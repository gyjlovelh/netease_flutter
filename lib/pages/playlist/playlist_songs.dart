import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';

class NeteasePlaylistSongs extends StatelessWidget {

  final PlaylistModel detail;
  
  NeteasePlaylistSongs({@required this.detail});  

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      child: Column(
        children: detail.tracks.asMap().map((index, song) {
          return MapEntry(index, ListTile(
            // 点击播放
            onTap: () {},
            // 复制歌曲名
            onLongPress: () {},
            leading: Text(
              (index + 1).toString()
            ),
            title: Text(
              song.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: screenUtil.setSp(32.0),
                fontWeight: FontWeight.w500
              ),
            ),
            // contentPadding: EdgeInsets.zero,
            subtitle: Text(
              song.ar.map((item) => item.name).join(',') + ' - ' + song.al.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.black54,
                fontSize: screenUtil.setSp(24.0)
              ),
            ),
            trailing: Container(
              // color: Colors.tealAccent,
              width: screenUtil.setWidth(120.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: NeteaseIconData(
                      0xe613
                    ),
                  ),
                  GestureDetector(
                    child: NeteaseIconData(
                      0xe8f5
                    ),
                  ),
                ],
              )
            ),
            dense: true,
            isThreeLine: false,
          ));
        }).values.toList(),
      )
    );
  }
}