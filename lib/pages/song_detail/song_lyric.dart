import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:provider/provider.dart';

class NeteaseSongLyric extends StatefulWidget {
  @override
  _NeteaseSongLyricState createState() => _NeteaseSongLyricState();
}

class _NeteaseSongLyricState extends State<NeteaseSongLyric> {

  var _lister;
  var _scrollListener;
  int _focusIndex = 0;

  // 歌词滚动控制
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
  
    scrollController = new ScrollController(initialScrollOffset: 0);

    _scrollListener = () {};
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    if (_lister != null) {
      _lister.cancel();
      _lister = null;
    }
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    final provider = Provider.of<PlayerStatusNotifier>(context);

    List seconds = provider.lyric.map((item) => item['second']).toList();

    if (_lister == null) {
      _lister = provider.audioPlayer.onAudioPositionChanged.listen((Duration d) {
        int index = seconds.indexOf(d.inSeconds);
        if (index != -1) {
          double offset = 40.0 * index;
          setState(() {
            _focusIndex = d.inSeconds; 
          });
          scrollController.animateTo(offset, duration: Duration(milliseconds: 1000), curve: Curves.ease);
        }
      });
    }

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
          itemExtent: 40.0,
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            var item = provider.lyric[index];

            return Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "${item['lyric']}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _focusIndex == item['second'] ? Colors.tealAccent : Colors.white,
                  fontSize: screenUtil.setSp(28.0),
                  shadows: [
                    Shadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: screenUtil.setWidth(8.0)
                    )
                  ]
                ),
              ),
            );
          }, childCount: provider.lyric.length),
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
}