import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NeteasePlaylistSongs extends StatelessWidget {

  final PlaylistModel detail;
  final LoadingStatus status;
  
  NeteasePlaylistSongs({@required this.detail, this.status});  

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayerStatusNotifier>(context);
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    

    String scStr = "0";
    if (status == LoadingStatus.LOADED) {
      if (detail.subscribedCount > 10000) {
        scStr = (detail.subscribedCount ~/ 1000 / 10).toString() + '万';
      } else {
        scStr = detail.subscribedCount.toString();
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.0),
          topLeft: Radius.circular(25.0)
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/theme_1.jpg'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.black12,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            child: ListTile(
              onTap: () async {
                if (provider.playerState == AudioPlayerState.PLAYING) {
                  await provider.stop();
                }
                demandProvider.choosePlayList(detail.tracks);
                // 播放第一首歌
                demandProvider.loadMusic(detail.tracks.first);
                provider.play();
              },
              onLongPress: () {},
              leading: NeteaseIconData(0xe674, color: Colors.white70),
              title: Text('播放全部', style: TextStyle(
                color: Colors.white70,
                fontSize: screenUtil.setSp(30.0)
              )),
              subtitle: status == LoadingStatus.LOADED ? Text('共${detail.trackCount.toString()}首', style: TextStyle(
                fontSize: screenUtil.setSp(22.0),
                color: Colors.white70,
              )) : Text(''),
              dense: true,
              trailing: RaisedButton(
                onPressed: () {},
                color: Theme.of(context).textSelectionColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Text('+ 收藏 ($scStr)', style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenUtil.setSp(24.0)
                ))
              ),
            ),
          ),
          drawSongs(context)
        ],
      )
    );
  }

  Widget drawSongs(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<PlayerStatusNotifier >(context);
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    final stateProvider = Provider.of<PlayerStatusNotifier>(context);

    if (status == LoadingStatus.LOADED) {
      return Container(
        height: screenUtil.setHeight(950),
        child: ListView.builder(
          itemCount: detail.tracks.length,
          itemExtent: screenUtil.setHeight(120.0),
          itemBuilder: (BuildContext context, int index) {
            SongModel song = detail.tracks[index];
            return Material(
              color: Colors.transparent,
              child: ListTile(
                // 点击播放
                onTap: () async {
                  if (song.url.isEmpty) {
                    Toast.show("亲爱的,暂无版权,么么哒~", context);
                  } else {
                    if (stateProvider.playerState == AudioPlayerState.PLAYING) {
                      await stateProvider.stop();
                    }
                    demandProvider.choosePlayList(detail.tracks);
                    demandProvider.loadMusic(song);
                    stateProvider.play();
                  }
                },
                // 复制歌曲名
                // onLongPress: () {},
                leading: Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenUtil.setSp(30.0)
                  ),
                ),
                enabled: song != null && song.url != null && song.url.isNotEmpty,
                title: Text(
                  song.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white70,
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
                    color: Colors.white54,
                    fontSize: screenUtil.setSp(24.0)
                  ),
                ),
                trailing: Container(
                  // color: Colors.tealAccent,
                  width: screenUtil.setWidth(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: NeteaseIconData(
                          0xe8f5,
                          color: Colors.white70,
                          size: screenUtil.setSp(42.0),
                        ),
                      ),
                    ],
                  )
                ),
                dense: true,
              )
            );
          }
        )
      );
    } else {
      return Container(
        height: screenUtil.setHeight(500.0),
        child: Center(
          child: NeteaseLoading()
        ),
      );
    }
  }
}