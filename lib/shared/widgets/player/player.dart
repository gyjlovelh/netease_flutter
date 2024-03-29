import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/player/player_control_btn.dart';
import 'package:provider/provider.dart';

import 'player_func_btn.dart';
import 'player_subtile.dart';

class NeteasePlayer extends StatefulWidget {
  @override
  _NeteasePlayerState createState() => _NeteasePlayerState();
}

class _NeteasePlayerState extends State<NeteasePlayer> {

  SongModel song = new SongModel();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    final demandProvider = Provider.of<PlayerSongDemand>(context);
    SongModel song =  demandProvider.currentMusic;
    
    return GestureDetector(
      onTap: () {
        if (song != null) {
          if (demandProvider.playMode == 1) {
            Navigator.of(context).pushNamed('song_detail');
          } else if (demandProvider.playMode == 2) {
            Navigator.of(context).pushNamed('personal_fm');
          }
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/player_bar_1.jpg'),
            fit: BoxFit.cover
          ),
          border: Border(
            top: BorderSide(
              width: screenUtil.setWidth(1.0),
              color: Colors.black12
            )
          )
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: screenUtil.setWidth(1.0),
                    color: Theme.of(context).primaryColor
                  ),
                  borderRadius: BorderRadius.circular(99.0),
                  image: DecorationImage(
                    image: song == null ? AssetImage('assets/images/song_cover_default.jpeg') : NetworkImage((song.al ?? song.album).picUrl),
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
                      song == null ? '' : song.name, 
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: SizeSetting.size_14
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    new PlayerSubtitle()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: new PlayerControlBtn()
            ),
            Expanded(
              flex: 0,
              child: new PlayerFuncBtn()
            )
          ],
        ),
      ),
    );
  }
}