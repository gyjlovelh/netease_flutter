import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:provider/provider.dart';

class NeteasePlaylistSongs extends StatelessWidget {

  final PlaylistModel detail;
  
  NeteasePlaylistSongs({@required this.detail});  

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<MusicChangeNotifier>(context);
    final stateProvider = Provider.of<MusicPlayerStatus>(context);

    String scStr;
    if (detail.subscribedCount > 10000) {
      scStr = (detail.subscribedCount ~/ 1000 / 10).toString() + '万';
    } else {
      scStr = detail.subscribedCount.toString();
    }

    return Container(
      margin: EdgeInsets.only(top: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.0),
          topLeft: Radius.circular(25.0)
        ),
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: NeteaseIconData(0xe674),
            title: Text('播放全部', style: TextStyle(
              fontSize: screenUtil.setSp(30.0)
            )),
            subtitle: Text('共' + detail.trackCount.toString() + '首', style: TextStyle(
              fontSize: screenUtil.setSp(22.0)
            )),
            dense: true,
            trailing: RaisedButton(
              onPressed: () {},
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Text('+ 收藏 ($scStr)', style: TextStyle(
                fontSize: screenUtil.setSp(24.0)
              ))
            ),
          ),
          Container(
            height: screenUtil.setHeight(900.0),
            child: ListView.builder(
              itemCount: detail.tracks.length,
              itemExtent: screenUtil.setHeight(120.0),
              itemBuilder: (BuildContext context, int index) {
                SongModel song = detail.tracks[index];
                return ListTile(
                  // 点击播放
                  onTap: () async {
                    if (stateProvider.playerState == AudioPlayerState.PLAYING) {
                      await stateProvider.stop();
                    }
                    provider.loadMusic(song);
                  },
                  // 复制歌曲名
                  onLongPress: () {},
                  leading: Text(
                    (index + 1).toString(),
                    textAlign: TextAlign.center
                  ),
                  title: Text(
                    song.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: screenUtil.setSp(30.0),
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
                    width: screenUtil.setWidth(110.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: NeteaseIconData(
                            0xe613,
                            size: screenUtil.setSp(42.0),
                          ),
                        ),
                        GestureDetector(
                          child: NeteaseIconData(
                            0xe8f5,
                            size: screenUtil.setSp(42.0),
                          ),
                        ),
                      ],
                    )
                  ),
                  dense: true,
                  isThreeLine: false,
                );
              },
            )
          )
        ],
      )
    );
  }
}