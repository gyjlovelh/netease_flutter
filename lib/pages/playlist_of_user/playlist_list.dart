import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/playlist_arguments.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';

class PlaylistList extends StatefulWidget {
  final int userId;
  final bool isCreator;

  PlaylistList({@required this.userId, @required this.isCreator});

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  LoadingStatus status = LoadingStatus.UNINIT;
  List _list = List();


  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (status == LoadingStatus.UNINIT) {
      _loadPageData();
      return Center(child: NeteaseLoading());
    } else {
      return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          PlaylistModel model = PlaylistModel.fromJson(_list[index]);
          return ListTile(
            onTap: () {
              PlaylistArguments arguments = new PlaylistArguments();
              arguments.id = model.id;
              arguments.name = model.name;
              arguments.coverImgUrl = model.coverImgUrl;

              Navigator.of(context).pushNamed('playlist', arguments: json.encode(arguments.toJson()));
            },
            leading: Container(
              width: screenUtil.setWidth(150.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0)),
                  child: Image.network(model.coverImgUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            title: Text(
              "${model.name}",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenUtil.setSp(28.0)
              ),
            ),
            subtitle: Text(
              "${model.trackCount}首，播放${model.playCount}次",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white54,
                fontSize: screenUtil.setSp(22.0)
              ),
            ),
          );
        },
      );
    }
  }

  void _loadPageData() async {
    final result = await RequestService.getInstance(context: context).getUserPlaylist(widget.userId);

    setState(() {
      status = LoadingStatus.LOADED;

      List list = result['playlist'];
      list = list.sublist(1).where((item) {
        if (widget.isCreator) {
          return item['userId'] == widget.userId;
        } else {
          return item['userId'] != widget.userId;
        }
      }).toList();
      _list = list;
    });
  }
}