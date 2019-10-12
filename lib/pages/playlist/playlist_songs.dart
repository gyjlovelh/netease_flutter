import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';

class NeteasePlaylistSongs extends StatelessWidget {

  final PlaylistModel detail;
  
  NeteasePlaylistSongs({@required this.detail});  

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      child: Column(
        children: detail.tracks.map((song) {

          return ListTile(
            // leading: Text('1'),
            title: Text(
              song.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: screenUtil.setSp(32.0),
                fontWeight: FontWeight.w500
              ),
            ),
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
                  Icon(Icons.play_circle_outline),
                  Icon(Icons.list)
                ],
              )
            ),
            dense: true,
          );
        }).toList(),
      )
    );
  }
}