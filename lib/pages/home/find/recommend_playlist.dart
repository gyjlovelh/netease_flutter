import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/playlist.dart';
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
            future: RequestService.getInstance().getRecommendPlaylist(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List playlist = (json.decode(snapshot.data.toString())['result'] as List).cast();

                return Wrap(
                  runSpacing: screenUtil.setHeight(8.0),
                  spacing: screenUtil.setWidth(14.0),
                  children: playlist.map((item) {
                    PlaylistModel model = PlaylistModel.fromJson(item);
                    String playCount;
                    if (model.playCount > 10000) {
                      playCount = (model.playCount ~/ 10000).toString() + '万';
                    } else {
                      playCount = model.playCount.toString() + '次';
                    }

                    return Container(
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
                              child: Text(
                                playCount,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Text(
                            model.name, 
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis
                          )
                        ],
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