import 'package:flutter/material.dart';

class MusicListVO {
    int id;
    String header;//leading
    String title; // name
    int trackCount;//歌曲数量
    MusicListVO({@required this.id,@required this.header,@required this.title,@required this.trackCount});

    @override
  String toString() {
    return 'header:'+this.header+',title:'+this.title+'trackCount:'+this.trackCount.toString();
  }
}