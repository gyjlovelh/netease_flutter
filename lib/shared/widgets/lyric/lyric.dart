import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/event/event.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:provider/provider.dart';

class NeteaseLyric extends StatefulWidget {
  @override
  _NeteaseLyricState createState() => _NeteaseLyricState();
}

class _NeteaseLyricState extends State<NeteaseLyric> {

  var _scrollListener;
  // 歌词列表下标
  int _focusIndex;
  // 歌词高亮位置
  int _activeMilliseconds;

  // 歌词滚动控制
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController(initialScrollOffset: 0);
    NeteaseEvent.getInstance().subscribe('netease.player.position.change', _whenPositionChange);

    _scrollListener = () {};
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    NeteaseEvent.getInstance().unsubscribe('netease.player.position.change', _whenPositionChange);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    List lyric = Provider.of<PlayerSongDemand>(context).lyric;

    return CustomScrollView(
      controller: scrollController,
      slivers :<Widget>[
        SliverFixedExtentList(
          itemExtent: screenUtil.setHeight(500.0),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container();
          }, childCount: 1)
        ),
        SliverFixedExtentList(
          itemExtent: 35.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            var item = lyric[index];

            return Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "${item['lyric']}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _activeMilliseconds == item['milliseconds'] ? Colors.tealAccent : Colors.white70,
                  fontSize: SizeSetting.size_14,
                  shadows: [
                    Shadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: screenUtil.setWidth(8.0)
                    )
                  ]
                ),
              ),
            );
          }, childCount: lyric.length),
        ),
        SliverFixedExtentList(
          itemExtent: screenUtil.setHeight(400.0),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return null;
          }, childCount: 1)
        ),
      ]
    );
  }

  void _whenPositionChange(var d) {
    List lyric = Provider.of<PlayerSongDemand>(context).lyric;
    if (mounted) {
      Duration duration = d;
      List milliseconds = lyric.map((item) => item['milliseconds']).toList();
      int index = milliseconds.indexWhere((millisecond) => millisecond >= duration.inMilliseconds);
      // todo 无法定位到最后一行歌词。
      if (index != -1 && _focusIndex != index) {
        double offset = 40.0 * index;
        setState(() {
          _focusIndex = index;
          _activeMilliseconds = milliseconds[index > 0 ? index - 1 : 0];
        });
        scrollController.animateTo(offset, duration: Duration(milliseconds: 1000), curve: Curves.ease);
      }
    }
  }
}