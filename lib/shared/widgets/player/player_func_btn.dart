import 'package:flutter/material.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:provider/provider.dart';

class PlayerFuncBtn extends StatefulWidget {
  @override
  _PlayerFuncBtnState createState() => _PlayerFuncBtnState();
}

class _PlayerFuncBtnState extends State<PlayerFuncBtn> {

  bool liked = false;

  @override
  Widget build(BuildContext context) {
    final demandProvider = Provider.of<PlayerSongDemand>(context);

    return Container(
      width: 40.0,
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.only(
        bottom: 1.0
      ),
      child: IconButton(
        onPressed: () {
          if (demandProvider.playMode == 1) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return new NeteaseMusicList();
              }
            );  
          } else if (demandProvider.playMode == 2) {
            _like(demandProvider.currentMusic.id);
          }
        },
        icon: NeteaseIconData(
          demandProvider.playMode == 1 ? 0xe604 : liked ? 0xe60b : 0xe616,
          size: 26.0,
          color: demandProvider.playMode == 2 && liked ? Colors.redAccent : Colors.white70,
        ),
      )
    );
  }

  void _like(int id) async {
    await RequestService.getInstance(context: context).addSongToFavourite(id, like: !liked);

    setState(() {
     liked = !liked; 
    });
  }
}