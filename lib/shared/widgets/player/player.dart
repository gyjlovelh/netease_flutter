import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:netease_flutter/shared/widgets/music_list/music_list.dart';
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

  int iconPointer(bool completed, AudioPlayerState state) {
    if (completed) {
      if (state == AudioPlayerState.PLAYING) {
        return 0xe6cb;
      } else {
        return 0xe674;
      }
    } else {
      return 0xe674;
    }
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    final provider = Provider.of<PlayerStatusNotifier>(context);
    SongModel song =  provider.currentMusic;

    // if (song == null) {
    //   return Text('no song');
    // }
    
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
                    image: song == null ? AssetImage('assets/images/song_cover_default.jpeg') : NetworkImage(song.al.picUrl),
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
                      "${provider?.currentMusic?.al?.name}",
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
              child: Container(
                width: screenUtil.setWidth(90.0),
                child: IconButton(
                  onPressed: () {
                    if (provider.playerState != AudioPlayerState.PLAYING) {
                        provider.play();
                      } else {
                        provider.pause();
                      }
                  },
                  color: Colors.white70,
                  disabledColor: Colors.grey,
                  icon: NeteaseIconData(
                    iconPointer(provider.currentMusic != null, provider.playerState),
                    size: screenUtil.setSp(54.0),
                    // color: Colors.white70,
                  ),
                )
              ),
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
                    size: screenUtil.setSp(54.0),
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