
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
import 'package:provider/provider.dart';

class RecordList extends StatefulWidget {
  final int type;
  final int userId;

  RecordList({@required this.type, @required this.userId});

  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  LoadingStatus status = LoadingStatus.UNINIT;

  List _list = List();

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final provider = Provider.of<PlayerStatusNotifier>(context);

    if (status == LoadingStatus.UNINIT) {
      _loadPageData();
      return Center(child: NeteaseLoading());
    }
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        SongModel song = SongModel.fromJson(_list[index]['song']);
        return ListTile(
          onTap: () async {
            // List<SongModel> songs = _list.map((item) => SongModel.fromJson(item)).toList();
            // stateController.choosePlayList(songs);
            // musicProvider.loadMusic(song);
            // stateController.play(musicProvider.currentMusic.url);
          },
          leading: Container(
            width: screenUtil.setWidth(50.0),
            child: Center(
              child: Text(
                "${index+1}",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: screenUtil.setSp(32.0)
                ),
              ),
            ),
          ),
          title: Text(
            "${song.name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenUtil.setSp(28.0)
            ),
          ),
          subtitle: Text(
            "${song.ar.map((item) => item.name).join(',')} - ${song.al.name}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white54,
              fontSize: screenUtil.setSp(20.0)
            ),
          ),
          dense: true,
        );
      },
    );
  }

  void _loadPageData() async {
    final result = await RequestService.getInstance(context: context).getUserRecord(uid: widget.userId, type: widget.type);
    setState(() {
      status = LoadingStatus.LOADING;
    });

    setState(() {
     status = LoadingStatus.LOADED;
      if (widget.type == 1) {
        _list = result['weekData'] ?? [];
      } else {
        _list = result['allData'] ?? [];
      }
    });
  }
}