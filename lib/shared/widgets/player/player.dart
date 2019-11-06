import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/player/player_song_demand.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
import 'package:netease_flutter/shared/widgets/player/player_control_btn.dart';
import 'package:provider/provider.dart';

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

    final provider = Provider.of<PlayerStatusNotifier>(context);
    final demandProvider = Provider.of<PlayerSongDemand>(context);
    SongModel song =  demandProvider.currentMusic;
    
    return GestureDetector(
      onTap: () {
        if (song != null) {
          Navigator.of(context).pushNamed('song_detail', arguments: {"id": song.id});
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
                width: screenUtil.setWidth(80.0),
                height: screenUtil.setWidth(80.0),
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
                      song == null ? '-' : song.name, 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenUtil.setSp(28.0)
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "${demandProvider?.currentMusic?.al?.name}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: screenUtil.setSp(20.0)
                      ),
                    )
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
              child: Container(
                width: screenUtil.setWidth(90.0),
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return new NeteaseMusicList();
                      }
                    );   
                  },
                  icon: NeteaseIconData(
                    0xe604,
                    size: screenUtil.setSp(50.0),
                    color: Colors.white70,
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