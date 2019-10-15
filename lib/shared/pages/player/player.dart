import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/pages/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player.dart';

class NeteasePlayer extends StatefulWidget {
  @override
  _NeteasePlayerState createState() => _NeteasePlayerState();
}

class _NeteasePlayerState extends State<NeteasePlayer> {

  NeteaseMusicController controller;

  SongModel song = new SongModel();

  @override
  void initState() {
    super.initState();

    controller = NeteaseMusicController.getInstance();
    song = controller.currentMusicInfo;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('song_detail', arguments: {"id": "123123123"});
      },
      child: Container(
        width: double.infinity,
        height: 12.0,
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: screenUtil.setWidth(80.0),
                height: screenUtil.setWidth(80.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: screenUtil.setWidth(1.0),
                    color: Colors.redAccent
                  ),
                  borderRadius: BorderRadius.circular(99.0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/theme.jpeg'),
                    fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '--',
                      style: TextStyle(
                        fontSize: screenUtil.setSp(30.0)
                      ),
                    ),
                    Text(
                      '作词/作曲 赵雷',
                      style: TextStyle(
                        fontSize: screenUtil.setSp(24.0)
                      ),
                    )
                  ],
                ),
            ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                width: screenUtil.setWidth(90.0),
                child: IconButton(
                  onPressed: () {
                    print('play_start...');
                  },
                  icon: NeteaseIconData(
                    0xe674,
                    size: screenUtil.setSp(54.0),
                    color: Colors.black54,
                  ),
                )
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                width: screenUtil.setWidth(90.0),
                child: IconButton(
                  onPressed: () {},
                  icon: NeteaseIconData(
                    0xe604,
                    size: screenUtil.setSp(54.0),
                    color: Colors.black54,
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  
}