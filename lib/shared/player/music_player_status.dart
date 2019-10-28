

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:provider/provider.dart';

import 'music_change.dart';

class MusicPlayerStatus with ChangeNotifier {

  // 背景播放器
  AudioPlayer _player;
  AudioPlayer get audioPlayer => _player;
  
  // 播放状态
  AudioPlayerState _playStatus = AudioPlayerState.STOPPED;

  // 播放当前位置和总时长
  int _current = 0;
  int get current => _current;
  int get duration => _player.duration.inSeconds;

  // 播放模式
  int _repeatNum = 0;
  RepeatMode _repeatMode = RepeatMode.LIST;
  RepeatMode get repeatMode => _repeatMode;

  // 播放列表
  List<SongModel> _musicList = [];

  MusicPlayerStatus() {
    this._player = new AudioPlayer();

    _player.onAudioPositionChanged.listen((Duration duration) {
      this._current = duration.inSeconds;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((AudioPlayerState state) {
      this._playStatus = state;
      notifyListeners();
      // print(state);
    });
  }

  AudioPlayerState get playerState => this._playStatus;

  Future play(String url) async {
    await this._player.play(url);
    this._playStatus = AudioPlayerState.PLAYING;
    // notifyListeners();
  }

  Future pause() async {
    await this._player.pause();
    this._playStatus = AudioPlayerState.PAUSED;
    // notifyListeners();
  }

  Future stop() async {
    await this._player.stop();
    this._current = 0;
    this._playStatus = AudioPlayerState.STOPPED;
    // notifyListeners();
  }

  /*
   * 切换播放模式
   */
  void changeRepeatMode() {
    _repeatNum = ++_repeatNum % 3;
    this._repeatMode = [RepeatMode.LIST, RepeatMode.RANDOM, RepeatMode.SINGLE][_repeatNum];
    notifyListeners();
  }

  // 追加歌曲待播放
  void addMusicItem(SongModel song) {
    _musicList.add(song);
  }

  // 选择歌单播放
  void choosePlayList(List<SongModel> list) {
    _musicList = list;
  }

  /*
   * 打开待播放列表弹框
   */
  void showMusicListSheet(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<MusicChangeNotifier>(context);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                        flatIconButton(
                          0xe61b, 
                          label: repeatMode == RepeatMode.LIST ? "列表循环"
                            : repeatMode == RepeatMode.RANDOM ? "随机播放" : "单曲循环", 
                          onPressed: () {
                            this.changeRepeatMode();
                          }
                        ),
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
                  itemCount: _musicList.length,
                  itemExtent: screenUtil.setHeight(100.0),
                  itemBuilder: (BuildContext context, int index) {
                    SongModel song = _musicList[index];
                    bool isCur = song.id == provider.currentMusic.id;

                    return ListTile(
                      onTap: () async {
                        provider.loadMusic(song);
                        stop();
                        play(provider.currentMusic.url);
                      },
                      onLongPress: () {},
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
                          color: Colors.white70,
                          size: screenUtil.setSp(32.0),
                        ),
                        onPressed: () {},
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
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
}

enum RepeatMode {
  // 列表循环
  LIST,
  // 随机播放
  RANDOM,
  // 单曲循环
  SINGLE
}
