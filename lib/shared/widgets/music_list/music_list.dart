import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_repeat_mode.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NeteaseMusicList extends StatefulWidget {
  @override
  _NeteaseMusicListState createState() => _NeteaseMusicListState();
}

class _NeteaseMusicListState extends State<NeteaseMusicList> {

  Widget repeatInfo() {
    return Consumer<PlayerRepeatMode>(
      builder: (context, notifier, _) {
        var mode = notifier.repeatMode;
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
          label: "$label(${Provider.of<PlayerSongDemand>(context).musicList.length})",
          onPressed: () {
            notifier.changeRepeatMode();
            Toast.show('$label', context);
          }
        );
      },
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
          fontSize: SizeSetting.size_14
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

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
            child: Consumer<PlayerSongDemand>(
              builder: (context, notifier, _) {
                return ListView.builder(
                  itemCount: notifier.musicList.length,
                  itemExtent: screenUtil.setHeight(100.0),
                  itemBuilder: (BuildContext context, int index) {
                    SongModel song = notifier.musicList[index];
                    bool isCur = song.id == notifier.currentMusic.id;

                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () async {
                          notifier.loadMusic(song);
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
                                "${song.name} - ${(song.ar ?? song.artists).map((item) => item.name).join(',')}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: isCur ? Theme.of(context).textSelectionColor : Colors.white70,
                                  fontSize: SizeSetting.size_14
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
                            if (isCur) {
                              //如果正在播放要删除的这首歌，则先播放下一曲。然后在删除
                              notifier.next();
                            }
                            notifier.removeMusicItem(song);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}