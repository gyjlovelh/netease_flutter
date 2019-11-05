import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/list_tile/list_tile.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';
import 'package:provider/provider.dart';

class NeteaseRecommendSongs extends StatefulWidget {
  @override
  _NeteaseCommendSongsState createState() => _NeteaseCommendSongsState();
}

class _NeteaseCommendSongsState extends State<NeteaseRecommendSongs> {

  List list = [];

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final demandProvider = Provider.of<PlayerSongDemand>(context);

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: '每日推荐',
      ),
      body: Container(
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme_1.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: ListView.builder(
          itemCount: list.length,
          // itemExtent: screenUtil.setHeight(120.0),
          itemBuilder: (BuildContext context, int index) {
            SongModel song = SongModel.fromJson(list[index]);
            return NeteaseListTile(
              listTile: ListTile(
                onTap: () {
                  demandProvider.choosePlayList(list.map((item) => SongModel.fromJson(item)).toList());
                  demandProvider.loadMusic(song);
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0)),
                  child: Image.network(
                    "${song.album.picUrl}",
                    fit: BoxFit.cover,
                    // width: screenUtil.setHeight(100.0),
                    // height: screenUtil.setHeight(100),
                  ),
                ),
                title: Text(
                  "${song.name}",
                  style: TextStyle(
                    fontSize: screenUtil.setSp(28.0),
                    color: Colors.white70
                  ),
                ),
                subtitle: Text(
                  "${song.artists.map((item) => item.name).join(',')} - ${song.album.name}",
                  style: TextStyle(
                    fontSize: screenUtil.setSp(20.0),
                    color: Colors.white54
                  ),
                ),
                dense: true,
              ),
            );
          },
        ),
      ),
    );
  }

  void _loadPageData() async {
    final result = await RequestService.getInstance(context: context).getRecommendSongs();
    setState(() {
      list = result;
    });
  }
}