

import 'package:flutter/foundation.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class MusicChangeNotifier with ChangeNotifier {
  // 当前音乐
  SongModel _song;
  // 当前音乐链接
  String _url;
  // 歌词
  List _lyric;

  SongModel get currentMusic => _song;

  String get musicUrl => _url;

  List get lyric => _lyric;

  void loadMusic(SongModel song) async {
    this.setCurrentMusic(song);
    RequestService.getInstance(context: null).getSongLyric(song.id).then((lyric) {
      this.setMusiclyric(lyric);
    });

    RequestService.getInstance(context: null).getSongUrl(song.id).then((url) {
      this.setMusicUrl(url);
    });
  }

  void setCurrentMusic(SongModel song) {
    this._song = song;
    notifyListeners();
  }

  void setMusicUrl(String url) {
    this._url = url;
    notifyListeners();
  }

  void setMusiclyric(List lyric) {
    this._lyric = lyric;
    notifyListeners();
  }
}