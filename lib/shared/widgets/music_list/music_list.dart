import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/music_change.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NeteaseMusicList extends StatefulWidget {
  @override
  _NeteaseMusicListState createState() => _NeteaseMusicListState();
}

class _NeteaseMusicListState extends State<NeteaseMusicList> {

  Widget repeatInfo() {
    final statProvider = Provider.of<MusicPlayerStatus>(context);
    var mode = statProvider.repeatMode;

    int pointer;
    String label;
    if (mode == RepeatMode.LIST) {
      pointer = 0xe63e;
      label = "列表循环";
    } else if (mode == RepeatMode.SINGLE) {
      pointer = 0xe640;
      label = "单曲循环";
    } else if (mode == RepeatMode.RANDOM) {
      pointer = 0xe61b;
      label = "随机播放";
    }

    return flatIconButton(
      pointer, 
      label: "$label(${statProvider.musicList.length})",
      onPressed: () {
        statProvider.changeRepeatMode();

        Toast.show('$label', context);
      }
    );
  }

  Widget flatIconButton(int pointer, {String label, VoidCallback onPressed}) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return FlatButton.icon(
      icon: NeteaseIconData(
        pointer,
        color: Colors.white,
        size: screenUtil.setSp(36.0),
      ),
      label: Text(
        "$label",
        style: TextStyle(
          color: Colors.white,
          fontSize: screenUtil.setSp(30.0)
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<MusicChangeNotifier>(context);
    final statProvider = Provider.of<MusicPlayerStatus>(context);

    return Container(
      color: Color.fromRGBO(58, 99, 120, 1),
      height: screenUtil.setHeight(750.0),
      child: Column(
        children: <Widget>[
          Container(
            height: screenUtil.setHeight(100.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: screenUtil.setWidth(1.0),
                  color: Colors.white10
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    repeatInfo()
                  ],
                ),
                Row(
                  children: <Widget>[
                    flatIconButton(0xe69f, label: "收藏全部", onPressed: () {

                    }),
                    IconButton(
                      icon: NeteaseIconData(
                        0xe67f,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: statProvider.musicList.length,
              itemExtent: screenUtil.setHeight(100.0),
              itemBuilder: (BuildContext context, int index) {
                SongModel song = statProvider.musicList[index];
                bool isCur = song.id == provider.currentMusic.id;

                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () async {
                      provider.loadMusic(song);
                      statProvider.stop();
                      statProvider.play(provider.currentMusic.url);
                    },
                    dense: true,
                    title: Row(
                      children: <Widget>[
                        isCur ? Container(
                          padding: EdgeInsets.only(right: screenUtil.setWidth(12.0)),
                          child: NeteaseIconData(
                            0xe666,
                            color: Theme.of(context).textSelectionColor,
                            size: screenUtil.setSp(32.0),
                          ),
                        ) : Text(''),
                        Container(
                          width: screenUtil.setWidth(500.0),
                          child: Text(
                            "${song.name} - ${song.ar.map((item) => item.name).join(',')}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: isCur ? Theme.of(context).textSelectionColor : Colors.white70,
                              fontSize: screenUtil.setSp(28.0)
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: NeteaseIconData(
                        0xe632,
                        color: isCur ? Theme.of(context).textSelectionColor : Colors.white70,
                        size: screenUtil.setSp(32.0),
                      ),
                      onPressed: () {
                        int index = statProvider.musicList.indexWhere((item) => item.id == song.id);
                        if (isCur) {
                          //如果正在播放要删除的这首歌，则先播放下一曲。然后在删除
                          statProvider.stop();
                          if (index == statProvider.musicList.length - 1) {
                            provider.loadMusic(statProvider.musicList.first);
                          } else {
                            provider.loadMusic(statProvider.musicList[index + 1]);
                          }
                          statProvider.play(provider.currentMusic.url);
                        }
                        statProvider.removeMusicItem(song);
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}