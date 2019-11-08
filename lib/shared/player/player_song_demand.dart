

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';

import 'player_repeat_mode.dart';

class PlayerSongDemand extends ChangeNotifier {
  SongModel _music = Global.getCurrentMusic();
  List<SongModel> _list = Global.getMusicList();

  SongModel get currentMusic => _music;
  List<SongModel> get musicList => _list;

  int _playMode = Global.playMode;
  int get playMode => _playMode;

  List _lyric = Global.getLyric(); 
  List get lyric => _lyric;

  PlayerSongDemand() {
    Global.player.onPlayerCompletion.listen((_) {
      if (Global.getRepeatMode() == RepeatMode.SINGLE) {
        Global.player.resume();
      } else {
         next();
      }
    });
  }

  // 加载歌曲
  Future loadMusic(SongModel song, {int playMode = 1}) async {
    return Future(() async {
      Global.setPlayMode(playMode);
      Global.player.release();
      if (Global.player.state != AudioPlayerState.STOPPED) {
        await Global.player.stop();
      }
      this._music = song;
      Global.updateCurrentMusic(song);
      this._playMode = playMode;
      await Global.player.play(song.url);
      notifyListeners();

      // 发布歌词
      _lyric = await RequestService.getInstance(context: null).getSongLyric(song.id);
      Global.updateLyric(_lyric);
      notifyListeners();
    });
  }

  // 追加歌曲待播放
  void addMusicItem(SongModel song) {
    if (_list.indexWhere((item) => item.id == song.id) != -1) return; 
    _list.insert(0, song);
    Global.updateMusicList(_list);
    notifyListeners();
  }

  // 移除歌曲
  void removeMusicItem(SongModel song) {
    int index = _list.indexWhere((item) => item.id == song.id);
    if (index >= 0 && index < _list.length) {
      _list.removeAt(index);
      Global.updateMusicList(_list);
      notifyListeners();
    }
  }

  // 选择歌单播放
  void choosePlayList(List<SongModel> list) {
    _list = list;
    Global.updateMusicList(_list);
    notifyListeners();
  }

  // 上一首⏮
  Future prev({BuildContext context}) async {
    int index = musicList.map((item) => item.id).toList().indexOf(currentMusic.id);
    ///TODO,上一首定位到历史播放的前一位。
    if (index == 0) {
      return loadMusic(musicList.last);
    } else {
      return loadMusic(musicList[index - 1]);
    }
  }
  // 下一首⏭
  Future next() async {
    var target;
    if (playMode == 1) { ///单曲模式
      int index = musicList.map((item) => item.id).toList().indexOf(currentMusic.id);
      if (Global.getRepeatMode() == RepeatMode.RANDOM) {
        target = musicList[Random().nextInt(musicList.length)];
      } else {
        if (index == musicList.length - 1) {
          target = musicList.first;
        } else {
          target = musicList[index + 1];
        }
      }
    } else if (playMode == 2) { ///FM模式
      int index = Global.getFmList().indexWhere((item) => currentMusic.id == item.id);
      if (index == -1) {
        print('FM列表没有这首歌????');
      } else {
        target = Global.getFmList()[index + 1];
      }
      ///当播放至倒数第二首时，往后加载FM列表
      if (index >= Global.getFmList().length - 2) {
        RequestService.getInstance(context: null).getPersonalFm().then((result) {
          List<SongModel> list = [];
          list..add(Global.getFmList().last)
            ..addAll(result.map<SongModel>((item) => SongModel.fromJson(item)).toList());

          Global.updateFmList(list);
          print("更新FM列表【${list.map((item) => item.name).join('】【')}】");
        });
      }
    }
    
    return loadMusic(target, playMode: playMode);
  }

}