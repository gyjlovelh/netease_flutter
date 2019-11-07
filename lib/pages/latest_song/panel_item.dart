import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/list_tile/list_tile.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
import 'package:provider/provider.dart';

class PanelItem extends StatefulWidget {
  final String label;
  final int type;
  PanelItem({@required this.type, @required this.label});

  @override
  _PanelItemState createState() => _PanelItemState();
}

class _PanelItemState extends State<PanelItem> {

  List<SongModel> songs = [];

  LoadingStatus status = LoadingStatus.UNINIT;

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget rowItem(SongModel song) {
    final demandProvider = Provider.of<PlayerSongDemand>(context);

    String coverUrl = "${(song.al ?? song.album).picUrl}" ?? "";

    return NeteaseListTile(
      listTile: ListTile(
        onTap: () {
          demandProvider.loadMusic(song);
          demandProvider.addMusicItem(song);
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: coverUrl.isEmpty ? Image.network(
            'assets/images/song_cover_default.jpeg',
            fit: BoxFit.cover,
            height: ScreenUtil.getInstance().setHeight(90),
            width: ScreenUtil.getInstance().setHeight(90),
          ) : Image.network(
            "$coverUrl",
            fit: BoxFit.cover,
            height: ScreenUtil.getInstance().setHeight(90),
            width: ScreenUtil.getInstance().setHeight(90),
          ),
        ),
        title: Text(
          '${song.name}',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeSetting.size_14,
          ),
        ),
        subtitle: Text(
          "${(song.ar ?? song.artists).map((item) => item.name).join(',')} - ${(song.al ?? song.album).name}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white60,
            fontSize: SizeSetting.size_10
          ),
        ),
        trailing: Container(
          width: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: NeteaseIconData(
                  0xe8f5,
                  color: Colors.white70,
                  size: SizeSetting.size_14,
                ),
              ),
            ],
          )
        ),
        dense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status != LoadingStatus.LOADED) {
      return Center(child: NeteaseLoading());
    }
    return CustomScrollView(
      slivers: <Widget>[
        SliverFixedExtentList(        // SliverList的语法糖，用于每个item固定高度的List
          delegate: SliverChildBuilderDelegate(
            (context, index) => rowItem(songs[index]),
            childCount: songs.length,
          ),
          itemExtent: ScreenUtil.getInstance().setHeight(120.0),
        ),
      ],
    );
  }

  void _loadPageData() async {
    List result = await RequestService.getInstance(context: context).getTopSong(widget.type);

    setState(() {
      songs = result.map((item) => SongModel.fromJson(item)).toList();
      status = LoadingStatus.LOADED;
    });
  }
}