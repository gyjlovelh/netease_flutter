import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/banner.dart';
import 'package:netease_flutter/models/recomment_playlist.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global_cache.dart';
import 'package:toast/toast.dart';

import 'icon_buttons.dart';
import 'recommend_playlist.dart';
import 'recommend_song.dart';
import 'swiper.dart';

class NeteaseFind extends StatefulWidget {
  @override
  _NeteaseFindState createState() => _NeteaseFindState();
}

class _NeteaseFindState extends State<NeteaseFind> {
  List<BannerModel> banners = [];
  List<RecommentPlaylistModel> playlist = [];
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    if (GlobalCache.getSwiperData().length == 0) {
      _loadSwiperData();
    } else {
      setState(() {
        banners = GlobalCache.getSwiperData();
      });
    }
    if (GlobalCache.getRecommendPlaylist().length == 0) {
      _loadPlaylistData();
    } else {
      setState(() {
        playlist = GlobalCache.getRecommendPlaylist();
      });
    }
    if (GlobalCache.getRecommendSong().length == 0) {
      _loadSongsData();
    } else {
      setState(() {
        songs = GlobalCache.getRecommendSong();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return RefreshIndicator(
      onRefresh: () async {
        await _loadSwiperData();
        await _loadPlaylistData();
        await _loadSongsData();
        Toast.show('已为你推荐新的个性化内容', context);
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            new NeteaseSwiper(banners: banners),
            new NeteaseIconButtons(),
            Divider(height: screenUtil.setHeight(66.0), color: Theme.of(context).primaryColor,),
            new NeteaseRecommentPlaylist(playlist: playlist),
            new RecommendSong(songs: songs)
          ],
        ),
      )
    );
  }

  Future _loadSwiperData() async {
    return Future(() async {
      final result = await RequestService.getInstance(context: context).getBanner();

      if (mounted) {
        setState(() {
          banners = result.map<BannerModel>((item) => BannerModel.fromJson(item)).toList();
          GlobalCache.cacheSwiperData(banners);
        });
      }
    });
  }

  Future _loadPlaylistData() async {
    return Future(() async {
      final result = await RequestService.getInstance(context: context).getRecommendPlaylist();

      if (mounted) {
        setState(() {
          playlist = result.map<RecommentPlaylistModel>((item) => RecommentPlaylistModel.fromJson(item)).toList();
          GlobalCache.cacheRecommendPlaylist(playlist);
        });
      }
    });
  }

  Future _loadSongsData() async {
    return Future(() async {
      final result = await RequestService.getInstance(context: context).getPersonalizedSongs();
    
      setState(() {
        songs = result.sublist(0, 3).map<SongModel>((item) => SongModel.fromJson(item['song'])).toList();
        GlobalCache.cacheRecommendSong(songs);
      });
    });
  }
}