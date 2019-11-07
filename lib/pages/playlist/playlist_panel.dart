import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
import 'package:netease_flutter/models/playlist_arguments.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/playcount/playcount.dart';

class NeteasePlaylistPanel extends StatefulWidget {

  final PlaylistModel detail;
  final PlaylistArguments arguments;
  final LoadingStatus status;
  
  NeteasePlaylistPanel({@required this.detail, this.arguments, this.status});

  @override
  _NeteasePlaylistPanelState createState() => _NeteasePlaylistPanelState();
}

class _NeteasePlaylistPanelState extends State<NeteasePlaylistPanel> {

  String getPlayCount(int playcount) {
    if (widget.status != LoadingStatus.LOADED || playcount == 0) {
      return "";
    }
    return playcount > 10000 ? (playcount ~/ 10000).toString() + '万' : playcount.toString() + '次';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    var detail = widget.detail ?? new PlaylistModel();

    Widget avatorW;
    if (widget.status == LoadingStatus.LOADED) {
      avatorW = Image.network(
        detail.creator.avatarUrl,
        fit: BoxFit.cover,
        width: screenUtil.setWidth(48.0),
        height: screenUtil.setWidth(48.0),
      );
    } else {
      avatorW = Image.asset(
        'assets/images/avator_default.jpeg',
        fit: BoxFit.cover,
        width: screenUtil.setWidth(48.0),
        height: screenUtil.setWidth(48.0),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenUtil.setWidth(28.0),
        vertical: screenUtil.setHeight(50.0)
      ),
      // color: Colors.tealAccent,
      child: Row(
        children: <Widget>[
          Container(
            width: screenUtil.setWidth(280.0),
            height: screenUtil.setWidth(280.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("${widget.arguments.coverImgUrl}"),
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0))
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: NeteasePlaycount(playCount: detail.playCount ?? 0)
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: screenUtil.setWidth(36.0)
            ),
            width: screenUtil.setWidth(414.0),
            height: screenUtil.setWidth(280.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.arguments.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeSetting.size_16
                  ),
                ),
                FlatButton(
                  onPressed: widget.status != LoadingStatus.LOADED ? null : () {
                    Navigator.of(context).pushNamed('user', arguments: detail.creator.userId);
                  },
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: avatorW
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenUtil.setWidth(14.0)),
                        child: Text(
                          widget.status == LoadingStatus.LOADED ? detail.creator.nickname : "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeSetting.size_12
                          ),
                        )
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: screenUtil.setSp(24.0))
                    ],
                  ),
                ),
                GestureDetector(
                  child: Text(
                    detail.description ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: SizeSetting.size_10
                    )
                  )
                )
              ],
            ),
          )
        ],
      )
    );                   
  }
}