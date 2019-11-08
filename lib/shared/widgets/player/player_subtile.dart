import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/event/event.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:provider/provider.dart';

class PlayerSubtitle extends StatefulWidget {
  @override
  _PlayerSubtitleState createState() => _PlayerSubtitleState();
}

class _PlayerSubtitleState extends State<PlayerSubtitle> {

  String subtitle = "";
  int _focusIndex = -1;

  @override
  void initState() {
    super.initState();
    NeteaseEvent.getInstance().subscribe('netease.player.position.change', _whenPositionChange);
  }

  @override
  void dispose() {
    NeteaseEvent.getInstance().unsubscribe('netease.player.position.change', _whenPositionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    final provider = Provider.of<PlayerStatusNotifier>(context);

    return Text(
      "${provider.playerState == AudioPlayerState.PLAYING ? subtitle : (demandProvider.currentMusic?.ar ?? demandProvider.currentMusic?.artists ?? []).map((item) => item.name).join(',')}",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        color: Colors.white70,
        fontSize: SizeSetting.size_10
      ),
    );
  }

  void _whenPositionChange(var d) {
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    List lyric = demandProvider.lyric;
    if (mounted) {
      Duration duration = d;
      List milliseconds = lyric.map((item) => item['milliseconds']).toList();
      int index = milliseconds.indexWhere((millisecond) => millisecond >= duration.inMilliseconds);
      if (index != -1 && _focusIndex != index) {
        setState(() {
          _focusIndex = index;
          subtitle = lyric[index > 0 ? index - 1 : 0]['lyric'];
        });
      }
    }
  }
}