import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:provider/provider.dart';

class PlayerFuncBtn extends StatefulWidget {
  @override
  _PlayerFuncBtnState createState() => _PlayerFuncBtnState();
}

class _PlayerFuncBtnState extends State<PlayerFuncBtn> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final demandProvider = Provider.of<PlayerSongDemand>(context);

    return Container(
      width: screenUtil.setWidth(90.0),
      child: IconButton(
        onPressed: () {
          if (demandProvider.playMode == 1) {
              showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return new NeteaseMusicList();
              }
            );  
          }
        },
        icon: NeteaseIconData(
          demandProvider.playMode == 1 ? 0xe604 : 0xe616,
          size: screenUtil.setSp(50.0),
          color: Colors.white70,
        ),
      )
    );
  }
}