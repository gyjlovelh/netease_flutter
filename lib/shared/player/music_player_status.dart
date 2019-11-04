

import 'dart:math';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:provider/provider.dart';

import 'player_repeat_mode.dart';
import 'player_song_demand.dart';

class PlayerStatusNotifier with ChangeNotifier {

  // 背景播放器
  AudioPlayer _player;
  BuildContext _context;

  // 播放状态
  AudioPlayerState _playStatus = Global.player.state;
  AudioPlayerState get playerState => _playStatus;


  // 歌词
  List _lyric;
  List get lyric => _lyric;

  PlayerStatusNotifier() {
    this._player = Global.player;

    this._player.onPlayerStateChanged.listen((AudioPlayerState state) {
      _playStatus = state;
      if (state == AudioPlayerState.COMPLETED) {
        next(context: _context);
      }
      notifyListeners();
    });
  }

  Future play({BuildContext context}) async {
    _context = context;
    await this._player.play("${Global.getCurrentMusic().url}");
    this._playStatus = AudioPlayerState.PLAYING;
  }

  //播放本地音乐
  Future playLocal(String path) async {
    await this._player.play(path,isLocal: true);
    this._playStatus = AudioPlayerState.PLAYING;
  }

  Future pause() async {
    await this._player.pause();
    this._playStatus = AudioPlayerState.PAUSED;
  }

  Future stop() async {
    await this._player.stop();
    this._playStatus = AudioPlayerState.STOPPED;
  }
  
  // 上一首⏮
  void prev({BuildContext context}) async {
    _context = context;
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    final musicList = demandProvider.musicList;
    int index = musicList.map((item) => item.id).toList().indexOf(demandProvider.currentMusic.id);
    stop();
    ///TODO,上一首定位到历史播放的前一位。
    if (index == 0) {
      demandProvider.loadMusic(musicList.last);
    } else {
      demandProvider.loadMusic(musicList[index - 1]);
    }
    play(context: context);
  }
  // 下一首⏭
  void next({BuildContext context}) async {
    _context = context;
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    final musicList = demandProvider.musicList;
    int index = musicList.map((item) => item.id).toList().indexOf(demandProvider.currentMusic.id);
    stop();
    var target;
    if (Global.getRepeatMode() == RepeatMode.RANDOM) {
      target = musicList[Random().nextInt(musicList.length)];
    } else {
      if (index == musicList.length - 1) {
        target = musicList.first;
      } else {
        target = musicList[index + 1];
      }
    }
    demandProvider.loadMusic(target);
    play(context: context);
  }

}

