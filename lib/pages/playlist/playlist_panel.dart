import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';

class NeteasePlaylistPanel extends StatefulWidget {

  final PlaylistModel detail;
  
  NeteasePlaylistPanel({@required this.detail});

  @override
  _NeteasePlaylistPanelState createState() => _NeteasePlaylistPanelState();
}

class _NeteasePlaylistPanelState extends State<NeteasePlaylistPanel> {

  String getPlayCount(int playcount) {
    return playcount > 10000 ? (playcount ~/ 10000).toString() + '万' : playcount.toString() + '次';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      height: screenUtil.setHeight(380.0),
      padding: EdgeInsets.symmetric(
        horizontal: screenUtil.setWidth(28.0),
        vertical: screenUtil.setHeight(50.0)
      ),
      // color: Colors.tealAccent,
      child: Row(
        children: <Widget>[
          Container(
            width: screenUtil.setWidth(280.0),
            height: screenUtil.setHeight(280.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.detail.coverImgUrl),
                fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(screenUtil.setWidth(12.0))
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: screenUtil.setWidth(12.0),
                  top: screenUtil.setHeight(5.0)
                ),
                child: Text(getPlayCount(widget.detail.playCount), style: TextStyle(
                  color: Colors.white,
                  fontSize: screenUtil.setSp(24.0),
                  shadows: [
                    Shadow(
                      color: Colors.black38, 
                      blurRadius: 2.0
                    )
                  ]
                )),
              )
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: screenUtil.setWidth(36.0)
            ),
            width: screenUtil.setWidth(414.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.detail.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: screenUtil.setSp(36.0)
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image.network(
                          widget.detail.creator.avatarUrl,
                          width: screenUtil.setWidth(60.0),
                          height: screenUtil.setHeight(60.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenUtil.setWidth(18.0)),
                        child: Text(widget.detail.creator.nickname)
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
                GestureDetector(
                  child: Text(
                    widget.detail.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: screenUtil.setSp(24.0)
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