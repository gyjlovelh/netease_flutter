import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/recomment_playlist.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class NeteaseRecommentPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenUtil.setWidth(28.0)
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('推荐歌单', style: TextStyle(
                fontSize: screenUtil.setSp(36.0),
                fontWeight: FontWeight.w500
              )),
              FlatButton(
                highlightColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: screenUtil.setWidth(1.0),
                    color: Colors.grey[400]
                  ),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 0
                ),
                child: Text('歌单广场', style: TextStyle(
                  fontSize: screenUtil.setSp(24.0),
                  fontWeight: FontWeight.w400
                )),
                onPressed: () {},
              )
            ],
          ),
          FutureBuilder(
            future: RequestService.getInstance(context: context).getRecommendPlaylist(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List playlist = snapshot.data;

                return Wrap(
                  runSpacing: screenUtil.setHeight(8.0),
                  spacing: screenUtil.setWidth(14.0),
                  children: playlist.map((item) {
                    RecommentPlaylistModel model = RecommentPlaylistModel.fromJson(item);
                    String playCount;
                    if (model.playCount > 10000) {
                      playCount = (model.playCount ~/ 10000).toString() + '万';
                    } else {
                      playCount = model.playCount.toString() + '次';
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('playlist', arguments: json.encode({"id": model.id, "copywriter": model.copywriter}).toString());
                      },
                      onLongPress: () {
                        return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(
                              model.copywriter,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenUtil.setSp(30.0)
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                  '查看详情',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: screenUtil.setSp(30.0),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: () {},
                              )
                            ],
                          )
                        );
                      },
                      child: Container(
                        width: screenUtil.setWidth(220.0),
                        height: screenUtil.setWidth(320.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                bottom: screenUtil.setHeight(8.0)
                              ),
                              width: screenUtil.setWidth(220.0),
                              height: screenUtil.setWidth(220.0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(model.picUrl),
                                  fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenUtil.setHeight(4.0),
                                    horizontal: screenUtil.setWidth(8.0)
                                  ),
                                  child: Text(
                                    playCount,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenUtil.setSp(20.0),
                                      shadows: [
                                        Shadow(
                                          offset: Offset.fromDirection(1.0),
                                          color: Colors.grey,
                                          blurRadius: 2.0
                                        )
                                      ]
                                    ),
                                  ),
                                )
                              ),
                            ),
                            Text(
                              model.name, 
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenUtil.setSp(24.0)
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Text('loading');
              }
            },
          )
        ],
      ),
    );
  }
}